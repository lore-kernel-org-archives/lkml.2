Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab0LHOHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 09:07:50 -0500
Received: from 26.mail-out.ovh.net ([91.121.27.225]:43796 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752655Ab0LHOHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 09:07:48 -0500
Date: Wed, 8 Dec 2010 15:03:13 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Igor Plyatov <plyatov@gmail.com>, Ryan Mallon <ryan@bluewatersys.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@maxim.org.za, linux@arm.linux.org.uk, costa.antonior@gmail.com
Subject: Re: [PATCH v2] mach-at91: Support for gms board added
Message-ID: <20101208140313.GD3429@game.jcrosoft.org>
References: <1291732927-9429-1-git-send-email-plyatov@gmail.com>
 <4CFE90CA.9050004@bluewatersys.com>
 <4CFF47A0.8010208@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CFF47A0.8010208@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 10460173085276351340
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:53 Wed 08 Dec     , Nicolas Ferre wrote:
> Hi Igor,
> 
> Le 07/12/2010 20:53, Ryan Mallon :
> > On 12/08/2010 03:42 AM, Igor Plyatov wrote:
> >> * The gms is a board from GeoSIG Ltd company.
> >>   It is based on the Stamp9G20 module from Taskit company.
> >> * This is a second version of the patch with adjustments according
> >>   to comments from Ryan Mallon.
> >> * This patch made for Linux 2.6.37-rc5.
> 
> First thank you for submitting this board support.
> 
> >> Signed-off-by: Igor Plyatov <plyatov@gmail.com>
> >> ---
> 
> [..]
> 
> > Couple more comments below.
> > Looking at this a bit more closely, the Stamp9G20 is a system on module
> > (SoM) board. The MACH_STAMP9G20 option supports the Stamp9G20 on
> > taskits's evaluation board and the MACH_PCONTROL_G20 option supports it
> > on the PControl carrier board. There is a reasonable amount of code
> > replication in each of the board files for the UARTs, NAND, MMC, etc.
> > 
> > Would it be better to have MACH_STAMPG20/board-stamp-9g20.c contain the
> > core support for the Stamp9G20 module and then each of the carrier board
> > files contain only the setup/devices found on the carrier board?
> 
> I have exactly the same feeling as Ryan. We should make sure 
> to factorize as much code as possible for maintenance reasons.
> 
> If you need to distinguish between board features, you can 
> pass information in system_rev as implemented in this 
> board merging commit:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a6e016f19d393fbe4e040bee8155b03b840fa689
I agree with nico not need to have a new board for just few difference

and as we start with the rm9200 we will reduce the number of defconfig first per soc and then for the all sam9

Best Regards,
J.
