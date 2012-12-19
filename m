Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab2LSQ5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 11:57:33 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:46212 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab2LSQ5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 11:57:25 -0500
Date: Wed, 19 Dec 2012 16:57:24 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH] ARM: OMAP4: PRM: fix RSTTIME and RSTST offsets
In-Reply-To: <1355911588-21977-3-git-send-email-ivan.khoronzhuk@ti.com>
Message-ID: <alpine.DEB.2.00.1212191657170.16873@utopia.booyaka.com>
References: <1355911588-21977-1-git-send-email-ivan.khoronzhuk@ti.com> <1355911588-21977-3-git-send-email-ivan.khoronzhuk@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2012, Ivan Khoronzhuk wrote:

> From: Nishanth Menon <nm@ti.com>
> 
> RSTTIME is offset 0x8 and RSTST is offset 0x04 for OMAP4430 and
> OMAP4460.
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> [ivan.khoronzhuk@ti.com: ported from k3.4]
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>

Thanks guys, queued for v3.8-rc fixes.

- Paul
