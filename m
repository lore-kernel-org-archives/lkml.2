Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab1GVP1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 11:27:06 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61696 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab1GVP1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 11:27:04 -0400
MIME-Version: 1.0
In-Reply-To: <1311220903-2545-1-git-send-email-jaswinder.singh@linaro.org>
References: <1311185906-7813-1-git-send-email-jaswinder.singh@linaro.org>
	<1311220903-2545-1-git-send-email-jaswinder.singh@linaro.org>
Date: Fri, 22 Jul 2011 17:27:03 +0200
Message-ID: <CACRpkdbWHmob3EWJc6u5=yh=rNwVSR5hu9-Xud5kvQNU9-POtA@mail.gmail.com>
Subject: Re: [PATCHv2] DMAEngine: Let dmac drivers to set chan_id
From: Linus Walleij <linus.walleij@linaro.org>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: linux-kernel@vger.kernel.org, vinod.koul@intel.com,
        dan.j.williams@intel.com, rmk+kernel@arm.linux.org.uk,
        linus.walleij@stericsson.com, per.friden@stericsson.com,
        wei.zhang@freescale.com, ebony.zhu@freescale.com, iws@ovro.caltech.edu,
        s.hauer@pengutronix.de, maciej.sosnowski@intel.com, saeed@marvell.com,
        shawn.guo@freescale.com, yur@emcraft.com, agust@denx.de,
        iwamatsu.nobuhiro@renesas.com, per.forlin@stericsson.com,
        jonas.aberg@stericsson.com, anemo@mba.ocn.ne.jp
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 6:01 AM, Jassi Brar <jaswinder.singh@linaro.org> wrote:

> A DMAC driver might put chan_id to better use by directly
> mapping system-wide channel numbers on them (and not DMAC
> relative index).

Sorry, not following this, is the idea that instead of each DMAC
numbering its own channels [0...N] you want to establish a global
channel index number [0..N] that is unique across all DMACs
in the system, even if you have several of them?

Yours,
Linus Walleij
