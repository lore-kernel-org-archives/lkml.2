Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab1LGJCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 04:02:00 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:20129 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab1LGJB7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 04:01:59 -0500
X-SpamScore: -15
X-BigFish: VS-15(zzc89bh179dN1432N98dKzz1202hzz8275dhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 7 Dec 2011 17:14:42 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: <netdev@vger.kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH][NET] several cleanups and bugfixes for fec.c: don't
 munge MAC address from platform data
Message-ID: <20111207091441.GF5550@S2100-06.ap.freescale.net>
References: <cover.1323163127.git.LW@KARO-electronics.de>
 <55b78c1766da5b0d0d679f5eae3fb9fc74a6ceef.1323163127.git.LW@KARO-electronics.de>
 <20111207084953.GD5550@S2100-06.ap.freescale.net>
 <20191.10281.826050.193987@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20191.10281.826050.193987@ipc1.ka-ro>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 09:47:37AM +0100, Lothar Waßmann wrote:
> Hi,
> 
> Shawn Guo writes:
> > On Tue, Dec 06, 2011 at 11:27:13AM +0100, Lothar Waßmann wrote:
> > > When the MAC address is supplied via platform_data it should be OK as
> > > it is and should not be modified in case of a dual FEC setup.
> > > Also copying the MAC from platform_data to the single 'macaddr'
> > > variable will overwrite the MAC for the first interface in case of a
> > > dual FEC setup.
> > 
> > Hmm, I do not follow that.  If 'macaddr' holds a valid mac address,
> > the code path has no chance to be hit at all.  Otherwise, 'macaddr'
> > is just a place holder for copying mac address from pdata, in which
> > case the mac address will be fixed up at the end of the function for
> > dual FEC setup.
> > 
> In case of dual FEC and MAC address provided by platform_data the
> first mac address will be copied to the 'macaddr' variable with no
> chance for the second interface to get its mac address assigned from
> platform_data too.
> 
Indeed.  So again other than subject,

Acked-by: Shawn Guo <shawn.guo@linaro.org>

-- 
Regards,
Shawn

