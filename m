Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab1KQWIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 17:08:15 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43396 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab1KQWIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 17:08:14 -0500
Subject: Re: [PATCH 1/3] mtd/nand: fix coding style issue in
 drivers/mtd/nand/fsl_elbc.c
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: b35362@freescale.com
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, leoli@freescale.com,
        scottwood@freescale.com
Date: Fri, 18 Nov 2011 00:08:08 +0200
In-Reply-To: <1321349355-1639-1-git-send-email-b35362@freescale.com>
References: <1321349355-1639-1-git-send-email-b35362@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1321567690.2272.24.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 17:29 +0800, b35362@freescale.com wrote:
> From: Liu Shuo <b35362@freescale.com>
> 
> fix whitespaces,tabs coding style issue and use #include <linux/io.h> instead of <asm/io.h>
> in drivers/mtd/nand/fsl_elbc.c.
> 
> Signed-off-by: Liu Shuo <b35362@freescale.com>
> Signed-off-by: Li Yang <leoli@freescale.com>

Hi, It is really matter of taste whether to use only tabs for
indentations or tabs + few spaces to align nicely with the previous
line. I personally prefer the latter and dislike when people use only
tabs. But other people love tabs and use them everywhere, even like
#define\tBLAH_BLAH\tvalue, which I find ugly, but I do not mind people
using this.

So no, please, let's leave the indentation as is in this file. It is ok
to assume tab is 8 spaces in the kernel.

Artem.

