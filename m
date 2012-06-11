Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab2FKOno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:43:44 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:48957 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755304Ab2FKOnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:43:42 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: b9GW7bEVM1nDmCgLAonFCVHYIBkc59y9uUaz4CKhUdBD0rG
 WZaJLjeETIb5sS5VxYd43DyLD9PXl7ivevJ4fXdwqDBYgFmdxuqJWSI.LiiY
 E.uTRTVmvc.hxqL6RsHUyNgCZZS138Q9I4CxsKssovDzIqR3in_L8eqfmmvJ
 FJkbm.oqSvALutC9T1yeYr6tWz2z9uRJnzT_Xrnjxqb9JYGKDo2ZVNfA56Ws
 R6OhvKOw0Z6dR7rA4gn0stZLgSgNpKTOhoIUgglMZk1pj2gbVG73LZcoie95
 PFNqipfR_6rff.KBxnQDnjPNhWKqxdbcP3x0nIjeB1ZiFOXjwPf9UCetMpyU
 f4vWxj1_w17Zx1NmB268BkmDhm1X3k6AGPf_Q_tZYJFOiDCb29.n_ZODSgEj
 zrv6NyMnukBIswdm27GJNyd.hd_deRA0IgG7d
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 11 Jun 2012 09:43:38 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@google.com>, Dave Jones <davej@redhat.com>,
        Mel Gorman <mgorman@suse.de>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 1/6] Revert "mm: mempolicy: Let vma_merge and vma_split
 handle vma->vm_policy linkages"
In-Reply-To: <1339406250-10169-2-git-send-email-kosaki.motohiro@gmail.com>
Message-ID: <alpine.DEB.2.00.1206110935070.31180@router.home>
References: <1339406250-10169-1-git-send-email-kosaki.motohiro@gmail.com> <1339406250-10169-2-git-send-email-kosaki.motohiro@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2012, kosaki.motohiro@gmail.com wrote:

> From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
>
> commit 05f144a0d5 "mm: mempolicy: Let vma_merge and vma_split handle
> vma->vm_policy linkages" removed a vma->vm_policy updates. But it is
> a primary purpose of mbind_range(). Now, mbind(2) is no-op in several
> case unintentionally. It is not ideal fix. This patch reverts it.

Rewritten changelog:

commit 05f144a0d5 "mm: mempolicy: Let vma_merge and vma_split handle
vma->vm_policy linkages" removed policy_vma() but the function is
needed in this patchset.


(It is not clear to me what the last sentences mean. AFAICT the code for
policy_vma() still exists in another function prior to this patch)


