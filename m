Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab2C0IY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 04:24:27 -0400
Received: from skyrme.org ([193.175.80.135]:34656 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404Ab2C0IYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 04:24:25 -0400
Date: 27 Mar 2012 08:24:19 +0000
Message-ID: <20120327082419.GA5080@curry>
From: "Oskar Schirmer" <oskar@scara.com>
To: "Marc Reilly" <marc@cpdesign.com.au>
Cc: sameo@linux.intel.com, linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-i2c@vger.kernel.org,
        u.kleine-koenig@pengutronix.de, oskar@scara.com,
        linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH v4 4/4] mfd: mc13xxx: Add i2c driver
References: <1332129838-7080-1-git-send-email-marc@cpdesign.com.au> <1332129838-7080-5-git-send-email-marc@cpdesign.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332129838-7080-5-git-send-email-marc@cpdesign.com.au>
User-Agent: Mutt/1.4.2.3i
Organisation: www.embedded-group.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Test against Linux 3.3 fails as crucial patches in regmap core
are not yet mainline. However, with commit cc374fbf5305 from
git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git
applied, this series works fine.

Signed-off-by: Oskar Schirmer <oskar@scara.com>

On Mon, Mar 19, 2012 at 15:03:58 +1100, Marc Reilly wrote:
> Adds support for mc13xxx family ICs connected via i2c.
> 
> Signed-off-by: Marc Reilly <marc@cpdesign.com.au>
> ---
>  drivers/mfd/Kconfig       |    8 +++-
>  drivers/mfd/Makefile      |    1 +
>  drivers/mfd/mc13xxx-i2c.c |  128 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 136 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/mfd/mc13xxx-i2c.c
[...]
