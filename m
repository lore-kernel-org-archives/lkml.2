Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab1FGQRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 12:17:33 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:33543 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab1FGQRb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 12:17:31 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-131.messagelabs.com!1307463441!12417087!21
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.180]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Grant Likely <grant.likely@secretlab.ca>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        Vinod Koul <vinod.koul@intel.com>
Date: Tue, 7 Jun 2011 11:17:26 -0500
Subject: RE: linux-next: manual merge of the gpio tree with the slave-dma
 tree
Thread-Topic: linux-next: manual merge of the gpio tree with the slave-dma
 tree
Thread-Index: AcwkvsY7pRLwF4Q0TaWQimkfJHrazgAb1Ugg
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F3820B7E0F@AUSP01VMBX24.collaborationhost.net>
References: <20110607125723.8e591e42.sfr@canb.auug.org.au>
In-Reply-To: <20110607125723.8e591e42.sfr@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 06, 2011 7:57 PM, Stephen Rothwell wrote:
> Hi Grant,
> 
> Today's linux-next merge of the gpio tree got a conflict in
> arch/arm/mach-ep93xx/Makefile between commit 8e4a93008db7 ("ep93xx:
> remove the old M2P DMA code") from the slave-dma tree and commit
> c6b52c13de44 ("gpio/ep93xx: move driver to drivers/gpio") from the gpio
> tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/mach-ep93xx/Makefile
> index 21e721a,6b7c41d..0000000
> --- a/arch/arm/mach-ep93xx/Makefile
> +++ b/arch/arm/mach-ep93xx/Makefile
> @@@ -1,7 -1,7 +1,7 @@@
>   #
>   # Makefile for the linux kernel.
>   #
> - obj-y			:= core.o clock.o gpio.o
>  -obj-y			:= core.o clock.o dma-m2p.o
> ++obj-y			:= core.o clock.o
>   obj-m			:=
>   obj-n			:=
>   obj-			:=

Stephen,

This is, of course, the correct fix.  If you want it:

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Thanks!