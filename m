Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab2E3UGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:06:07 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:20799 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750903Ab2E3UGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:06:05 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 1GJbBcgVM1mx8YrYzmd25KreD0reaFFQlFoJeKScuwhrbed
 .3dfJ7tLBmnBPvJt2Ydg7vvMZIEayGKNRCnXpvucQdjKJCgnBrN2b3aBfVWt
 P2V23lhLBfSEbZYAUZGeQ3Q9S.erRKZ6F41RORtYifVfxRRZSZeZ8gjgD4xG
 AnwjSiDJRkFvSOTrQIFbXUN3ammCi29C75csrOAKMtl8MNG2erAIkCl1yiPW
 5IdA7Qyj2oZuaHaSKiVMaStiARncotLJwgciLHgzjWM.N8YB0LS2QFoDScxo
 G1IdginOUJHy9ys_nYF8B1ezrbzweT874wpOlMEkoLzIwfxiB7ZIqpPFbRSV
 cPTvPPdAVYlWVxYUOBh_3KU3mjhfArWop8Gq.pCbN9sshJ_55f7GgCp6BgYd
 g65lP9WrVbkSjwE8x65DpddtTtUpe0HTkSGjF
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 30 May 2012 14:44:14 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@google.com>, Dave Jones <davej@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org,
        hughd@google.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/6] Revert "mm: mempolicy: Let vma_merge and vma_split
 handle vma->vm_policy linkages"
In-Reply-To: <CAHGf_=oLsK2bk_ym6EZfFD=uRpr33CL+1=nWmf4hrnCxUOFisQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205301443020.31768@router.home>
References: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com> <1338368529-21784-2-git-send-email-kosaki.motohiro@gmail.com> <alpine.DEB.2.00.1205301414020.31768@router.home> <CAHGf_=oLsK2bk_ym6EZfFD=uRpr33CL+1=nWmf4hrnCxUOFisQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2012, KOSAKI Motohiro wrote:

> > You are dropping the nice comments by Mel that explain the refcounting.
>
> Because this is not strictly correct. 1) vma_merge() and split_vma() don't
> care mempolicy refcount. They only dup and drop it. 2) This mpol_get() is
> for vma attaching. This function don't need to care sp_node internal.

Ok then say so in the changelog.


