Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab2IURw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 13:52:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932208Ab2IURw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 13:52:56 -0400
Date: Fri, 21 Sep 2012 14:52:43 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Richard Davies <richard@arachsys.com>, Shaohua Li <shli@kernel.org>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        QEMU-devel <qemu-devel@nongnu.org>, KVM <kvm@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/9] Revert "mm: have order > 0 compaction start off
 where it left"
Message-ID: <20120921175242.GG6665@optiplex.redhat.com>
References: <1348224383-1499-1-git-send-email-mgorman@suse.de>
 <1348224383-1499-8-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348224383-1499-8-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 11:46:21AM +0100, Mel Gorman wrote:
> This reverts commit 7db8889a (mm: have order > 0 compaction start off
> where it left) and commit de74f1cc (mm: have order > 0 compaction start
> near a pageblock with free pages). These patches were a good idea and
> tests confirmed that they massively reduced the amount of scanning but
> the implementation is complex and tricky to understand. A later patch
> will cache what pageblocks should be skipped and reimplements the
> concept of compact_cached_free_pfn on top for both migration and
> free scanners.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Acked-by: Rik van Riel <riel@redhat.com>
> ---

Acked-by: Rafael Aquini <aquini@redhat.com>

