Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab2FKD4U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 23:56:20 -0400
Received: from linux-sh.org ([111.68.239.195]:50114 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244Ab2FKD4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 23:56:18 -0400
Date: Mon, 11 Jun 2012 12:55:43 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, horms@verge.net.au,
        linux@arm.linux.org.uk, arnd@arndb.de, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl, olof@lixom.net
Subject: Re: [PATCH 00/08] mach-shmobile: Emma Mobile EV2 support V3
Message-ID: <20120611035543.GD10170@linux-sh.org>
References: <20120516064449.32286.77941.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120516064449.32286.77941.sendpatchset@w520>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 03:44:49PM +0900, Magnus Damm wrote:
> mach-shmobile: Emma Mobile EV2 support V3
> 
> [PATCH 01/08] mach-shmobile: Emma Mobile EV2 SoC base support V3
> [PATCH 02/08] ARM: Undelete KZM9D mach-type V3
> [PATCH 03/08] mach-shmobile: KZM9D board support V3
> [PATCH 04/08] mach-shmobile: Emma Mobile EV2 SMP support V3
> [PATCH 05/08] mach-shmobile: Emma Mobile EV2 GPIO support V3
> [PATCH 06/08] mach-shmobile: KZM9D board Ethernet support V3
> [PATCH 07/08] mach-shmobile: Emma Mobile EV2 DT support V3
> [PATCH 08/08] mach-shmobile: Use DT_MACHINE for KZM9D V3
> 
Now that this series has hit mainline I notice that no defconfig is
available for the board, so there's no way to have any coverage in it in
-next. When we're at a point where multiple boards are enabled in one
config then they can be consolidated, but it's not acceptable to have a
platform upstream that people have no way of building.
