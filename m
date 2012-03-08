Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836Ab2CHWTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:19:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34459 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758728Ab2CHWTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:19:39 -0500
Date: Thu, 8 Mar 2012 14:19:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Tyler Hicks <tyhicks@canonical.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-mm@kvack.org, davej@redhat.com, jboyer@redhat.com,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] hugetlbfs: lockdep annotate root inode properly
Message-Id: <20120308141938.1d04afb7.akpm@linux-foundation.org>
In-Reply-To: <20120308214951.GB23916@ZenIV.linux.org.uk>
References: <1331198116-13670-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20120308130256.c7855cbd.akpm@linux-foundation.org>
	<20120308211926.GB6546@boyd>
	<20120308134050.f53a0b2f.akpm@linux-foundation.org>
	<20120308214951.GB23916@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2012 21:49:52 +0000
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> > So we need to pull the i_mutex out of hugetlbfs_file_mmap().
> 
> IIRC, you have a patch in your tree doing just that...

Nope.

But it seems that you've recently seen such a patch - can you recall
where?  Or was it the ecryptfs thing?

