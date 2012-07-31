Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab2GaMdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 08:33:54 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:51851 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2GaMdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 08:33:53 -0400
MIME-Version: 1.0
In-Reply-To: <1339406250-10169-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1339406250-10169-1-git-send-email-kosaki.motohiro@gmail.com>
Date: Tue, 31 Jul 2012 08:33:52 -0400
Message-ID: <CA+5PVA4CE0kwD1FmV=081wfCObVYe5GFYBQFO9_kVL4JWJBqpA@mail.gmail.com>
Subject: Re: [PATCH 0/6][resend] mempolicy memory corruption fixlet
From: Josh Boyer <jwboyer@gmail.com>
To: kosaki.motohiro@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@google.com>, Dave Jones <davej@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Christoph Lameter <cl@linux.com>,
        stable@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 5:17 AM,  <kosaki.motohiro@gmail.com> wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>
> Hi
>
> This is trivial fixes of mempolicy meory corruption issues. There
> are independent patches each ather. and, they don't change userland
> ABIs.
>
> Thanks.
>
> changes from v1: fix some typo of changelogs.
>
> -----------------------------------------------
> KOSAKI Motohiro (6):
>   Revert "mm: mempolicy: Let vma_merge and vma_split handle
>     vma->vm_policy linkages"
>   mempolicy: Kill all mempolicy sharing
>   mempolicy: fix a race in shared_policy_replace()
>   mempolicy: fix refcount leak in mpol_set_shared_policy()
>   mempolicy: fix a memory corruption by refcount imbalance in
>     alloc_pages_vma()
>   MAINTAINERS: Added MEMPOLICY entry
>
>  MAINTAINERS    |    7 +++
>  mm/mempolicy.c |  151 ++++++++++++++++++++++++++++++++++++++++----------------
>  mm/shmem.c     |    9 ++--
>  3 files changed, 120 insertions(+), 47 deletions(-)

I don't see these patches queued anywhere.  They aren't in linux-next,
mmotm, or Linus' tree.  Did these get dropped?  Is the revert still
needed?

josh
