Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab2IYFiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 01:38:05 -0400
Received: from londo.lunn.ch ([80.238.139.98]:44515 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab2IYFiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 01:38:02 -0400
Date: Tue, 25 Sep 2012 07:37:53 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Dove fixes for arm-soc/for-next
Message-ID: <20120925053753.GL14266@lunn.ch>
References: <1348531338-16624-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348531338-16624-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 02:02:12AM +0200, Sebastian Hesselbarth wrote:
> With the current speed of changes within arm kernel tree, there
> have been some issues related to the mach-dove DT support patches
> introduced lately. This patch set keeps up with the changes between
> initial patch submission and current status of arm-soc/for-next.
> 
> Sebastian Hesselbarth (6):
>   ARM: dove: Add pcie clock support
>   ARM: dove: Fix tauros2 device tree init
>   ARM: dove: Fix clock names of sata and gbe
>   ARM: dove: Restructure SoC device tree descriptor
>   ARM: dove: Remove watchdog from DT
>   ARM: dove: Add crypto engine to DT
> 
>  arch/arm/boot/dts/dove.dtsi |   49 ++++++++++++++++++++++++++++---------------
>  arch/arm/mach-dove/common.c |    8 +++----
>  arch/arm/mach-dove/pcie.c   |    5 +++++
>  3 files changed, 41 insertions(+), 21 deletions(-)

Its a bit late, Jason has already sent the pull request. But:

Acked-by: Andrew Lunn <andrew@lunn.ch>

None of my questions should be considered as NACKs for these patches.

     Andrew
