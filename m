Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab1L2HAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 02:00:35 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:10100
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751157Ab1L2HAc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 02:00:32 -0500
X-SpamScore: -9
X-BigFish: VS-9(zzc89bh1432N98dKzz1202hzzz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 29 Dec 2011 15:14:08 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Dirk Behme <dirk.behme@googlemail.com>
CC: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>,
        <netdev@vger.kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH][NET] several cleanups and bugfixes for fec.c
Message-ID: <20111229071407.GA11474@S2100-06.ap.freescale.net>
References: <cover.1323163127.git.LW@KARO-electronics.de>
 <4EFC0AE4.6020608@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <4EFC0AE4.6020608@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 29, 2011 at 07:38:28AM +0100, Dirk Behme wrote:
> On 06.12.2011 11:27, Lothar Waßmann wrote:
> >The following set of patches provides some cleanup and bugfixes for
> >drivers/net/ethernet/freescale/fec.c and makes the driver buildable as
> >a module.
> >
> >Lothar WaÃŸmann (8):
> >   misc cleanups
> >   set con_id in clk_get() call to NULL
> >   prevent dobule restart of interface on FDX/HDX change
> >   don't request invalid IRQ
> >   don't munge MAC address from platform data
> >   preserve MII/RMII setting in fec_stop()
> >   fix the .remove code
> >   make FEC driver buildable as module
> >
> >  drivers/net/ethernet/freescale/Kconfig |    2 +-
> >  drivers/net/ethernet/freescale/fec.c   |   63 ++++++++++++++++++++++----------
> >  2 files changed, 44 insertions(+), 21 deletions(-)
> 
> What's the status of this patch series?
> 
> If I remember correctly, most of them got an Ack or Tested-by from
> Shawn? But one or two need an update (not sure, though)? And the
> subject should be updated?
> 
The series with update has been picked up by David on net-next.
The LAKML was just missed from the updated posting.

-- 
Regards,
Shawn

