Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab1KCSHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 14:07:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:57374 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961Ab1KCSHW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 14:07:22 -0400
Subject: Re: [PATCH] mcu_mpc8349emitx.c: add shutdown request support
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1313417970-28098-1-git-send-email-fabio.baltieri@gmail.com>
Date: Thu, 3 Nov 2011 13:07:10 -0500
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <3051811F-3000-44B1-B207-01D654E453E3@kernel.crashing.org>
References: <1313417970-28098-1-git-send-email-fabio.baltieri@gmail.com>
To: Fabio Baltieri <fabio.baltieri@gmail.com>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 15, 2011, at 9:19 AM, Fabio Baltieri wrote:

> This patch add support for calling ctrl_alt_del() when the power button is
> pressed for more than about 2 seconds on some freescale MPC83xx
> evaluation boards and reference design.
> 
> The code uses a kthread to poll the CTRL_BTN bit each second.
> 
> Also change Kconfig entry of the driver to bool, as device's gpio
> registration is broken when loading as module.
> 
> Tested on an MPC8315E RDB board.
> 
> Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
> ---
> arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c |   58 +++++++++++++++++++++++-
> arch/powerpc/platforms/Kconfig                 |    2 +-
> 2 files changed, 58 insertions(+), 2 deletions(-)

applied

- k