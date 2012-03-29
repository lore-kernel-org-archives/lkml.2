Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760293Ab2C2Wxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 18:53:55 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:52203 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760168Ab2C2Wxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 18:53:50 -0400
Message-ID: <4F74E7CD.3030807@ah.jp.nec.com>
Date: Thu, 29 Mar 2012 18:53:01 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Organization: NEC Corporation
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] pagemap: fix order of pmd_trans_unstable() and pmd_trans_huge_lock()
References: <1333010501-31218-1-git-send-email-n-horiguchi@ah.jp.nec.com> <20120329202514.GC20930@redhat.com>
In-Reply-To: <20120329202514.GC20930@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(3/29/2012 16:25), Andrea Arcangeli wrote:
> Hi,
> 
> On Thu, Mar 29, 2012 at 04:41:41AM -0400, Naoya Horiguchi wrote:
>> pmd_trans_unstable() in pagemap_pte_range() comes before pmd_trans_huge_lock()
>> now, which means that pagewalk kicked by reading /proc/pid/pagemap does not
>> run over thp. This patch fixes it.
> 
> This should be fixed already.

Oh, you're right. Thanks.
