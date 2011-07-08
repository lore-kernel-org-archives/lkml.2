Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab1GHWMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 18:12:53 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:35265
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285Ab1GHWMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 18:12:51 -0400
X-SpamScore: -12
X-BigFish: VS-12(zz1102K1432N98dKzz1202hzz8275bhz2dh2a8h668h839h64h)
X-Spam-TCS-SCL: 3:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4E1780DA.3090800@freescale.com>
Date: Fri, 8 Jul 2011 17:12:42 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: <kumar.gala@freescale.com>, <benh@kernel.crashing.org>, <akpm@kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-console@vger.kernel.org>, <alan@lxorguk.ukuu.org.uk>,
        <arnd@arndb.de>
Subject: Re: tty/powerpc: introduce the ePAPR embedded hypervisor byte channel
 driver
References: <1305830092-20104-1-git-send-email-timur@freescale.com> <20110708220654.GA19146@kroah.com>
In-Reply-To: <20110708220654.GA19146@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>> > 3) A tty driver, which is used to handle user-space input and output.  The
>> > byte channel used for the console is designated as the default tty.
>> > 
>> > Signed-off-by: Timur Tabi <timur@freescale.com>
> Doesn't apply at all to the tty-next tree, so I can't apply it here :(

I shall take care of that right now.

-- 
Timur Tabi
Linux kernel developer at Freescale

