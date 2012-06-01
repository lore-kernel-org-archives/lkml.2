Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048Ab2FAOPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:15:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932595Ab2FAOPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:15:06 -0400
Date: Fri, 1 Jun 2012 10:14:59 -0400
From: Dave Jones <davej@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: WARNING: at mm/page-writeback.c:1990
 __set_page_dirty_nobuffers+0x13a/0x170()
Message-ID: <20120601141459.GC1732@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
References: <20120530163317.GA13189@redhat.com>
 <20120531005739.GA4532@redhat.com>
 <20120601023107.GA19445@redhat.com>
 <alpine.LSU.2.00.1206010030050.8462@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1206010030050.8462@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 01:44:44AM -0700, Hugh Dickins wrote:
 > So I'm wondering if your trinity fuzzer happens to succeed a lot more
 > often on madvise MADV_REMOVEs than fallocate FALLOC_FL_PUNCH_HOLEs, and
 > the bug you converged on is not in tmpfs, but in ext4 (or xfs? or ocfs2?),
 > which began to support MADV_REMOVE with that commit.

One more thing: I happened to see this during a kernel build last night
on another machine too, so it's not just fuzzing fallout. I'm surprised more
people aren't seeing it.

	Dave

