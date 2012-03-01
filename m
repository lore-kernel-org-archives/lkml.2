Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259Ab2CAWoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 17:44:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51312 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758178Ab2CAWop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 17:44:45 -0500
Date: Thu, 1 Mar 2012 14:44:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, linux-mm@kvack.org,
        mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        viro@zeniv.linux.org.uk, hughd@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V2] hugetlbfs: Drop taking inode i_mutex lock from
 hugetlbfs_read
Message-Id: <20120301144443.7b4fe22a.akpm@linux-foundation.org>
In-Reply-To: <CA+5PVA4AcTWHsUskGqxdka2G7JMsDpjtdhw23vSHafgAGg4opQ@mail.gmail.com>
References: <1330593530-2022-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20120301141007.274ad458.akpm@linux-foundation.org>
	<CA+5PVA4AcTWHsUskGqxdka2G7JMsDpjtdhw23vSHafgAGg4opQ@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 1 Mar 2012 17:40:41 -0500
Josh Boyer <jwboyer@gmail.com> wrote:

> We've gotten a few lockdep reports about it in Fedora on various kernels.
> A CC to stable might be nice.
> 

On Thu, 1 Mar 2012 17:40:14 -0500
Dave Jones <davej@redhat.com> wrote:

> My testing hits this every day. It's not a real problem, but it's annoying
> to see the lockdep spew constantly.  We've had a couple Fedora users
> report it too in regular day-to-day use as opposed to the hostile
> workloads I use to provoke it.
> 
> FWIW, I'll probably throw it in the Fedora kernels, so if it ends up
> in stable, it'll be one less patch to carry.

OK, thanks guys.  Cc:stable is added.
