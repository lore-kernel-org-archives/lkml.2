Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab2F0IfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 04:35:10 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40485 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab2F0IfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 04:35:03 -0400
Date: Wed, 27 Jun 2012 01:35:02 -0700 (PDT)
Message-Id: <20120627.013502.1720347414481981219.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] sparc32: Remove superfluous extern declarations
 for prom_*() functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <1340211487-24534-2-git-send-email-geert@linux-m68k.org>
References: <1340211487-24534-1-git-send-email-geert@linux-m68k.org>
	<1340211487-24534-2-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 20 Jun 2012 18:58:07 +0200

> prom_meminit() and prom_ranges_init() are declared in <asm/oplib_32.h>.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied.
