Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab2DSIXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 04:23:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221Ab2DSIXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 04:23:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1334767915-4870-1-git-send-email-abhat38@gmail.com>
References: <1334767915-4870-1-git-send-email-abhat38@gmail.com> <1>
To: anirudh bhat <abhat38@gmail.com>
Cc: dhowells@redhat.com, arve@android.com, chris+android@zenthought.org,
        hpa@zytor.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        anirudh bhat <anirudhbhat@ubuntu.ubuntu-domain>
Subject: Re: [PATCH 2/2] staging:android:fix line over 80 characters issue in binders.c this patch fixes line over 80 characters warning that was found using checkpatch.pl tool Signed-off-by:Anirudh Bhat <abhat38@gmail.com>
Date: Thu, 19 Apr 2012 09:22:58 +0100
Message-ID: <14565.1334823778@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

anirudh bhat <abhat38@gmail.com> wrote:

> -		printk(KERN_ERR "binder: %d: binder_alloc_buf failed to "
> -		       "map pages in userspace, no vma\n", proc->pid);
> +		printk(KERN_ERR "binder: %d: binder_alloc_buf failed to map pages in userspace, no vma\n",
> +			proc->pid);

Are these the wrong way round?  Surely these are introducing checkpatch
warnings rather than curing them?

If checkpatch is complaining about:

	printk(KERN_ERR "binder: %d: binder_alloc_buf failed to "
	       "map pages in userspace, no vma\n", proc->pid);

being a string split over multiple lines, then *checkpatch* needs to be fixed.

David
