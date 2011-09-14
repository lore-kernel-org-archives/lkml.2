Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab1INGwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 02:52:13 -0400
Received: from mail-gx0-f170.google.com ([209.85.161.170]:38815 "EHLO
	mail-gx0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab1INGwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 02:52:09 -0400
Date: Tue, 13 Sep 2011 23:52:22 -0700
From: Andrew Morton <akpm00@gmail.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Kirill Shutemov <kirill@shutemov.name>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Nathan Lynch <ntl@pobox.com>, Zan Lynx <zlynx@acm.org>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Tejun Heo <tj@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/2] fs, proc: Introduce the /proc/<pid>/map_files/
 directory v12
Message-Id: <20110913235222.043927b3.akpm@linux-foundation.org>
In-Reply-To: <20110913212447.918816776@openvz.org>
References: <20110913211359.674453213@openvz.org>
	<20110913212447.918816776@openvz.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Sep 2011 01:14:01 +0400 Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> This one behaves similarly to the /proc/<pid>/fd/ one - it contains symlinks
> one for each mapping with file, the name of a symlink is "vma->vm_start-vma->vm_end",
> the target is the file. Opening a symlink results in a file that point exactly
> to the same inode as them vma's one.

We should fully work through Pavel Machek's comments, please.  For some
reason I'm a bit paranoid about security lately :(
