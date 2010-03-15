Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936458Ab0COOQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 10:16:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:48717 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936310Ab0COOQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 10:16:11 -0400
Date: Mon, 15 Mar 2010 15:16:09 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] MTD: drop +x perms on C source files
In-Reply-To: <1267808420-27330-1-git-send-email-vapier@gentoo.org>
Message-ID: <alpine.LNX.2.00.1003151515480.18642@pobox.suse.cz>
References: <1267808420-27330-1-git-send-email-vapier@gentoo.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Mar 2010, Mike Frysinger wrote:

> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  0 files changed, 0 insertions(+), 0 deletions(-)
>  mode change 100755 => 100644 drivers/mtd/chips/cfi_util.c
>  mode change 100755 => 100644 drivers/mtd/inftlcore.c
> 
> diff --git a/drivers/mtd/chips/cfi_util.c b/drivers/mtd/chips/cfi_util.c
> old mode 100755
> new mode 100644
> diff --git a/drivers/mtd/inftlcore.c b/drivers/mtd/inftlcore.c
> old mode 100755
> new mode 100644

This has already been fixed tree-wide by commit c14e522b1aab6a1a.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
