Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512Ab2E3JEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 05:04:25 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42845 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383Ab2E3JEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 05:04:23 -0400
Message-ID: <4FC5E293.5060608@gmail.com>
Date: Wed, 30 May 2012 05:04:19 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-mm@kvack.org, Andrew Morton <akpm@google.com>,
        Dave Jones <davej@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, stable@vger.kernel.org,
        hughd@google.com, kosaki.motohiro@gmail.com
Subject: This is mistake message
References: <1338367958-21442-1-git-send-email-kosaki.motohiro@gmail.com>
In-Reply-To: <1338367958-21442-1-git-send-email-kosaki.motohiro@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/30/12 4:52 AM), kosaki.motohiro@gmail.com wrote:
> KOSAKI Motohiro (6):
>    Revert "mm: mempolicy: Let vma_merge and vma_split handle
>      vma->vm_policy linkages"
>    mempolicy: Kill all mempolicy sharing
>    mempolicy: fix a race in shared_policy_replace()
>    mempolicy: fix refcount leak in mpol_set_shared_policy()
>    mempolicy: fix a memory corruption by refcount imbalance in
>      alloc_pages_vma()
>    MAINTAINERS: Added MEMPOLICY entry
> 
>   MAINTAINERS    |    7 +++
>   mm/mempolicy.c |  151 ++++++++++++++++++++++++++++++++++++++++----------------
>   mm/shmem.c     |    9 ++--
>   3 files changed, 120 insertions(+), 47 deletions(-)

Oh my good. My script sent garbage text. I'm sorry. Please trash this.


