Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab2LQSYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 13:24:38 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:38940 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab2LQSYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 13:24:36 -0500
Date: Mon, 17 Dec 2012 18:24:35 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 2/2] ARM: OMAP4: PRCM: Fix incorrect read of reset
 sources
In-Reply-To: <1355765191-21545-2-git-send-email-ivan.khoronzhuk@ti.com>
Message-ID: <alpine.DEB.2.00.1212171824270.29833@utopia.booyaka.com>
References: <1355765191-21545-1-git-send-email-ivan.khoronzhuk@ti.com> <1355765191-21545-2-git-send-email-ivan.khoronzhuk@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, 17 Dec 2012, Ivan Khoronzhuk wrote:

> The address of PRM_RSTST register and flag mask are incorrect,
> so fix it.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>

arch/arm/mach-omap2/prcm.c no longer exists in current mainline; please
rebase this against Linus' current tree.


- Paul
