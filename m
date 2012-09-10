Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab2IJCl6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 22:41:58 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:50400 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751258Ab2IJCl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 22:41:57 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 173.50.127.139
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Lq07gP5wluvzE5hHjtKnEFJl74iHADOI=
Date: Sun, 9 Sep 2012 22:41:50 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Rabeeh Khoury <rabeeh@solid-run.com>,
        Maen Suleiman <maen@marvell.com>, Olof Johansson <olof@lixom.net>,
        Ian Molton <ian.molton@codethink.co.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/6] ARM: dove: DT support for Marvell Dove
Message-ID: <20120910024149.GU4575@titan.lakedaemon.net>
References: <1344681326-17946-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1345050455-32643-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345050455-32643-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 07:07:29PM +0200, Sebastian Hesselbarth wrote:
> This patch set adds DT support for Marvell Dove SoC and three boards
> equipped with this SoC. The work is based on device tree support for
> Marvell Orion based SoCs introduced in 3.6-rc1.
> 
> The first three patches move mach-dove closer to Marvell Kirkwood's
> setup code by unifying the clock setup routines, adding clock gating
> control, and support for Marvell's crypto engine to mach-dove.
> 
> Patches 4 and 5 add a generic DT machine descriptor to mach-dove and
> corresponding DT descriptors for the SoC and already supported boards.
> 
> Finally, the last patch adds a DT descriptor for the SolidRun CuBox,
> a plug computer based on Marvell Dove.
> 
> This patch set relies on a DT support patch for sdhci-dove that has
> been accepted on mmc-next for 3.7 as commit
> b2293055c1e1200acbb46523976852d1686fdfa4.
> 
> Changes:
> v2: removed clk_prepare_enable for tclk and updated subsequent patches
> v3: fixed a typo in clk_gate name for pex0
>     removed device name macros from clk gate names
> 
> Sebastian Hesselbarth (6):
>   ARM: dove: unify clock setup
>   ARM: dove: add clock gating control
>   ARM: dove: add crypto engine
>   ARM: dove: add device tree based machine descriptor
>   ARM: dove: add device tree descriptors
>   ARM: dove: SolidRun CuBox DT
> 
>  arch/arm/boot/dts/dove-cm-a510.dts   |   38 +++++++++
>  arch/arm/boot/dts/dove-cubox.dts     |   42 +++++++++
>  arch/arm/boot/dts/dove-dove-db.dts   |   38 +++++++++
>  arch/arm/boot/dts/dove.dtsi          |  143 +++++++++++++++++++++++++++++++
>  arch/arm/mach-dove/Kconfig           |    7 ++
>  arch/arm/mach-dove/Makefile.boot     |    4 +
>  arch/arm/mach-dove/common.c          |  156 +++++++++++++++++++++++++++++++---
>  arch/arm/mach-dove/include/mach/pm.h |   54 ++++++++----
>  8 files changed, 452 insertions(+), 30 deletions(-)
>  create mode 100644 arch/arm/boot/dts/dove-cm-a510.dts
>  create mode 100644 arch/arm/boot/dts/dove-cubox.dts
>  create mode 100644 arch/arm/boot/dts/dove-dove-db.dts
>  create mode 100644 arch/arm/boot/dts/dove.dtsi
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Whole series applied to:

git://git.infradead.org/users/jcooper/linux.git kirkwood/boards

thx,

Jason.
