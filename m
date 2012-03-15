Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161415Ab2COUTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 16:19:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42913 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161119Ab2COUTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:19:15 -0400
Date: Thu, 15 Mar 2012 13:19:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-mm@kvack.org, Jiri Slaby <jirislaby@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Too much free memory (not used for FS cache)
Message-Id: <20120315131913.657d4f3d.akpm@linux-foundation.org>
In-Reply-To: <4F624C88.6050503@suse.cz>
References: <4F624C88.6050503@suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2012 21:09:44 +0100
Jiri Slaby <jslaby@suse.cz> wrote:

> since today's -next (20120315), the MM/VFS system is very sluggish.
> Especially when committing, diffing and similar with git. I still have
> 2G of 6G of memory free. But with each commit I have to wait for git to
> fetch all data from disk.
> 
> I'm using ext4 on a raid for the partition with git kernel repository if
> that matters.
> 
> Any idea what that could be?

The last mm->next update was March 5th so it won't be from stuff in the
-mm queue.

Are you sure it's reclaim-related?  Perhaps something in the IO system
got slow?




