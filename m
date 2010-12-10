Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab0LJXA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 18:00:59 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48529 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab0LJXA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 18:00:58 -0500
Subject: Re: [PATCH 0/9] regulators: Update ab8500 regulator driver
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@stericsson.com>
In-Reply-To: <1291975728-12525-1-git-send-email-bengt.g.jonsson@stericsson.com>
References: <1291975728-12525-1-git-send-email-bengt.g.jonsson@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 23:00:54 +0000
Message-ID: <1292022054.3422.23.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-10 at 11:08 +0100, Bengt Jonsson wrote:
> This patchset updates the ab8500 regulator driver:
> * The first patch modifies the ab8500 platform configuration structure.
> * Patches two through eight updates the ab8500 regulator driver.
> * The ninth patch modifies the ab8500 regulator configuration.
> 
> The eighth patch is optional as discussed before.
> 
> Bengt Jonsson (9):
>   regulators: Moved define for number of regulators in ab8500
>   regulators: Fixed errors in ab8500 register mapping
>   regulators: Clean out unused code in ab8500 regulators
>   regulators: Added ab8500 v2 support
>   regulators: Updated ab8500 variable names, macro names and comments
>   regulators: Modified ab8500 error handling
>   regulators: Added verbose debug messages to ab8500 regulators
>   regulators: Removed macros for initialization of ab8500 regulators
>   mach-ux500: Updated and connected ab8500 regulator board
>     configuration
> 
>  arch/arm/mach-ux500/board-mop500-regulators.c |  153 ++++-----
>  arch/arm/mach-ux500/board-mop500-regulators.h |   19 +
>  arch/arm/mach-ux500/board-mop500.c            |    3 +
>  drivers/regulator/ab8500.c                    |  448 +++++++++++++++++--------
>  include/linux/mfd/ab8500.h                    |    5 +-
>  include/linux/regulator/ab8500.h              |   24 +-
>  6 files changed, 426 insertions(+), 226 deletions(-)
>  create mode 100644 arch/arm/mach-ux500/board-mop500-regulators.h
> 

All applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

