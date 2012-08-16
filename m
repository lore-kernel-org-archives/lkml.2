Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372Ab2HPVW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 17:22:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63329 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932650Ab2HPVWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 17:22:54 -0400
Date: Thu, 16 Aug 2012 14:22:49 -0700
From: Tejun Heo <tj@kernel.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/6] system_highpri_wq
Message-ID: <20120816212249.GH24861@google.com>
References: <Yes>
 <1345040741-5508-1-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345040741-5508-1-git-send-email-js1304@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 11:25:35PM +0900, Joonsoo Kim wrote:
> Change from v2
> [1/6] No change
> [2/6] Change local variable name and use it directly for TP
> [3/6] Add a comment.
> [4/6] No change
> [5/6] Add a comment. Fix ugly indentation.
> [6/6] No change
> 
> Change from v1
> [ALL] Add cover-letter
> [ALL] Rebase on git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.7
> 
> [1/6] No change
> [2/6] First added into this series.
> [3/6] Add change log to clarify what pacth do,
>       Add logic to handle the case "@cpu is WORK_CPU_UNBOUND"
> [4/6] Fix awsome mistake: Set WQ_HIGHPRI for system_highpri_wq
> [5/6] Adopt Tejun's comment about selection system_wq
> [6/6] No change
> 
> This patchset introduce system_highpri_wq
> in order to use proper cwq for highpri worker.
> 
> First 3 patches are not related to that purpose.
> Just fix arbitrary issues.
> Last 3 patches are for our purpose.

Applied to wq/for-3.7 w/ minor updates.

Thanks.

-- 
tejun
