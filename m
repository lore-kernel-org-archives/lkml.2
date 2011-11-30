Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab1K3DjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 22:39:15 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:53648 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752076Ab1K3DjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 22:39:13 -0500
Message-ID: <1322624351.17214.5.camel@Joe-Laptop>
Subject: Re: [PATCH 16/28] namespace: checkpatch wanking
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 29 Nov 2011 19:39:11 -0800
In-Reply-To: <20111130022245.GS2203@ZenIV.linux.org.uk>
References: <cover.1322609672.git.joe@perches.com>
	 <a3527806b3af190204da9de1df1bfe4421ed6101.1322609673.git.joe@perches.com>
	 <20111130022245.GS2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 02:22 +0000, Al Viro wrote:
> On Tue, Nov 29, 2011 at 06:14:14PM -0800, Joe Perches wrote:
> > Fix a few style things.
> > $ ./scripts/checkpatch.pl -f --terse --nosummary fs/namespace.c | \
> >   cut -f3- -d":" | sort | uniq -c
> >       1  ERROR: do not initialise statics to 0 or NULL
> >       2  ERROR: do not use assignment in if condition
> >       1  ERROR: "foo * bar" should be "foo *bar"
> >       1  ERROR: need consistent spacing around '|' (ctx:VxW)
> >       1  WARNING: braces {} are not necessary for single statement blocks
> >       3  WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> >       4  WARNING: line over 80 characters
> >       9  WARNING: please, no space before tabs
> >       1  WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
> >       1  WARNING: Use #include <linux/unistd.h> instead of <asm/unistd.h>
> NAK.  First of all, wanking it certainly is; moreover, it creates shitloads
> of conflicts with patches in vfs.git#vfsmount-guts

No worries.

I think patches 1 thru 14 are reasonable though
and do apply with a few offsets to vfsmount-guts.


