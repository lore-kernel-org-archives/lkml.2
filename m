Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab1KQKsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 05:48:19 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45686 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab1KQKsR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 05:48:17 -0500
MIME-Version: 1.0
In-Reply-To: <4EC30C0C.9020409@xenotime.net>
References: <20111115131742.f9ebaf818fd152ef779f4d19@canb.auug.org.au> <4EC30C0C.9020409@xenotime.net>
From: Mark Einon <mark.einon@gmail.com>
Date: Thu, 17 Nov 2011 10:48:01 +0000
Message-ID: <CANK3SE2aKCSN7aDTLGZ1SrUCgVfh7MQsLd8TC4CDEumnQS_bUg@mail.gmail.com>
Subject: Re: [PATCH -next] staging: fix more ET131X build errors
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 November 2011 01:04, Randy Dunlap <rdunlap@xenotime.net> wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>
> ET131X is a network device, so it should depend on
> NETDEVICES.  (This part won't be needed when the driver
> moves to drivers/net/.)  It also uses PHYLIB interfaces,
> so it should select PHYLIB.  Fixes these build errors:
>
> ERROR: "phy_connect" [drivers/staging/et131x/et131x.ko] undefined!
> ERROR: "phy_find_first" [drivers/staging/et131x/et131x.ko] undefined!
> ERROR: "mdiobus_register" [drivers/staging/et131x/et131x.ko] undefined!
> ERROR: "mdiobus_alloc" [drivers/staging/et131x/et131x.ko] undefined!
> ERROR: "phy_stop" [drivers/staging/et131x/et131x.ko] undefined!
> ERROR: "phy_start" [drivers/staging/et131x/et131x.ko] undefined!
> ERROR: "mdiobus_free" [drivers/staging/et131x/et131x.ko] undefined!
> ERROR: "mdiobus_unregister" [drivers/staging/et131x/et131x.ko] undefined!
> ERROR: "phy_print_status" [drivers/staging/et131x/et131x.ko] undefined!
> ERROR: "phy_ethtool_gset" [drivers/staging/et131x/et131x.ko] undefined!
> ERROR: "phy_ethtool_sset" [drivers/staging/et131x/et131x.ko] undefined!
> ERROR: "phy_mii_ioctl" [drivers/staging/et131x/et131x.ko] undefined!
>
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: : Mark Einon <mark.einon@gmail.com>
