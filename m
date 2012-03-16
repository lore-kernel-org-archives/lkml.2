Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423146Ab2CPQVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 12:21:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:47046 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030239Ab2CPQVB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 12:21:01 -0400
Subject: Re: [PATCH v3 4/4] powerpc: Board support for GE IMP3A
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1331572380-1064-5-git-send-email-martyn.welch@ge.com>
Date: Fri, 16 Mar 2012 11:14:00 -0500
Cc: linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <613D20C2-EBE3-435C-89F0-8C858A344DED@kernel.crashing.org>
References: <1331572380-1064-1-git-send-email-martyn.welch@ge.com> <1331572380-1064-5-git-send-email-martyn.welch@ge.com>
To: Martyn Welch <martyn.welch@ge.com>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 12, 2012, at 12:13 PM, Martyn Welch wrote:

> Initial board support for the GE IMP3A, a 3U compactPCI card with a p2020
> processor.
> 
> Signed-off-by: Martyn Welch <martyn.welch@ge.com>
> ---
> 
> v2: Rebase patch onto powerpc/next, taking work by Kyle Moffett into
>    account.
> 
> v3: Correct detection of interrupt controller.
> 
> arch/powerpc/boot/dts/ge_imp3a.dts      |  255 ++++++++++++++++++++++++++++++
> arch/powerpc/configs/ge_imp3a_defconfig |  257 +++++++++++++++++++++++++++++++
> arch/powerpc/platforms/85xx/Kconfig     |   15 ++
> arch/powerpc/platforms/85xx/Makefile    |    1 +
> arch/powerpc/platforms/85xx/ge_imp3a.c  |  246 +++++++++++++++++++++++++++++
> drivers/gpio/gpio-ge.c                  |   28 ++++
> 6 files changed, 802 insertions(+), 0 deletions(-)
> create mode 100644 arch/powerpc/boot/dts/ge_imp3a.dts
> create mode 100644 arch/powerpc/configs/ge_imp3a_defconfig
> create mode 100644 arch/powerpc/platforms/85xx/ge_imp3a.c

applied, moved defconfig to configs/85xx/

- k