Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293Ab2DFWst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 18:48:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab2DFWss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 18:48:48 -0400
Date: Fri, 6 Apr 2012 15:48:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Eric Paris <eparis@redhat.com>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 6/7] mm: kill vma flag VM_EXECUTABLE
Message-Id: <20120406154846.ada3cf0f.akpm@linux-foundation.org>
In-Reply-To: <4F7A8544.2020603@openvz.org>
References: <20120331091049.19373.28994.stgit@zurg>
	<20120331092929.19920.54540.stgit@zurg>
	<20120402231837.GC32299@count0.beaverton.ibm.com>
	<4F7A8544.2020603@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Apr 2012 09:06:12 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> Ok, I'll resend this patch as independent patch-set,
> anyway I need to return mm->mmap_sem locking back.

We need to work out what to do with "c/r: prctl: add ability to set new
mm_struct::exe_file".  I'm still sitting on the 3.4 c/r patch queue for
various reasons, one of which is that I need to go back and re-review
all the discussion, which was lengthy.  Early next week, hopefully.

