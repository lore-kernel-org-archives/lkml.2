Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018Ab2CHWd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:33:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889Ab2CHWd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:33:57 -0500
Date: Thu, 8 Mar 2012 17:33:34 -0500
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Tyler Hicks <tyhicks@canonical.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-mm@kvack.org, jboyer@redhat.com, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] hugetlbfs: lockdep annotate root inode properly
Message-ID: <20120308223333.GA21766@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Tyler Hicks <tyhicks@canonical.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-mm@kvack.org, jboyer@redhat.com, linux-kernel@vger.kernel.org,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	David Gibson <david@gibson.dropbear.id.au>
References: <1331198116-13670-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20120308130256.c7855cbd.akpm@linux-foundation.org>
 <20120308211926.GB6546@boyd>
 <20120308134050.f53a0b2f.akpm@linux-foundation.org>
 <20120308214951.GB23916@ZenIV.linux.org.uk>
 <20120308141938.1d04afb7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308141938.1d04afb7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 02:19:38PM -0800, Andrew Morton wrote:
 > On Thu, 8 Mar 2012 21:49:52 +0000
 > Al Viro <viro@ZenIV.linux.org.uk> wrote:
 > 
 > > > So we need to pull the i_mutex out of hugetlbfs_file_mmap().
 > > 
 > > IIRC, you have a patch in your tree doing just that...
 > 
 > Nope.
 > 
 > But it seems that you've recently seen such a patch - can you recall
 > where?

this ? https://lkml.org/lkml/2012/2/23/64

	Dave
