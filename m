Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab1K3CWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:22:51 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36396 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757446Ab1K3CWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:22:47 -0500
Date: Wed, 30 Nov 2011 02:22:45 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/28] namespace: checkpatch wanking
Message-ID: <20111130022245.GS2203@ZenIV.linux.org.uk>
References: <cover.1322609672.git.joe@perches.com>
 <a3527806b3af190204da9de1df1bfe4421ed6101.1322609673.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3527806b3af190204da9de1df1bfe4421ed6101.1322609673.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 06:14:14PM -0800, Joe Perches wrote:
> Fix a few style things.
> 
> $ ./scripts/checkpatch.pl -f --terse --nosummary fs/namespace.c | \
>   cut -f3- -d":" | sort | uniq -c
>       1  ERROR: do not initialise statics to 0 or NULL
>       2  ERROR: do not use assignment in if condition
>       1  ERROR: "foo * bar" should be "foo *bar"
>       1  ERROR: need consistent spacing around '|' (ctx:VxW)
>       1  WARNING: braces {} are not necessary for single statement blocks
>       3  WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
>       4  WARNING: line over 80 characters
>       9  WARNING: please, no space before tabs
>       1  WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
>       1  WARNING: Use #include <linux/unistd.h> instead of <asm/unistd.h>

NAK.  First of all, wanking it certainly is; moreover, it creates shitloads
of conflicts with patches in vfs.git#vfsmount-guts
