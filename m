Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423100Ab2CPQOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 12:14:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:36888 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422959Ab2CPQOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 12:14:04 -0400
Subject: Re: [PATCH v3 1/4] powerpc: Add GE FPGA config option
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1331572380-1064-2-git-send-email-martyn.welch@ge.com>
Date: Fri, 16 Mar 2012 11:13:38 -0500
Cc: linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Content-Transfer-Encoding: 7bit
Message-Id: <1EB0BB40-016C-4082-9112-13A0EE0BAEB3@kernel.crashing.org>
References: <1331572380-1064-1-git-send-email-martyn.welch@ge.com> <1331572380-1064-2-git-send-email-martyn.welch@ge.com>
To: Martyn Welch <martyn.welch@ge.com>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 12, 2012, at 12:12 PM, Martyn Welch wrote:

> This patch adds the GE_FPGA configuration option. This is being carried
> out as ground work to allow the PIC and GPIO drivers to be move from the
> powerpc 86xx platform directory to more general locations to allow them to
> be used on non-86xx boards and to reduce churn when further boards using
> these drivers are added.
> 
> Signed-off-by: Martyn Welch <martyn.welch@ge.com>
> ---
> 
> v3: Broken out from patch moving PIC and GPIO drivers
> 
> arch/powerpc/platforms/86xx/Kconfig  |    7 +++++++
> arch/powerpc/platforms/86xx/Makefile |    7 ++++---
> drivers/watchdog/Kconfig             |    2 +-
> 3 files changed, 12 insertions(+), 4 deletions(-)

applied

- k
