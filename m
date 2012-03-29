Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619Ab2C2UZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 16:25:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759127Ab2C2UZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 16:25:21 -0400
Date: Thu, 29 Mar 2012 22:25:14 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] pagemap: fix order of pmd_trans_unstable() and
 pmd_trans_huge_lock()
Message-ID: <20120329202514.GC20930@redhat.com>
References: <1333010501-31218-1-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333010501-31218-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 29, 2012 at 04:41:41AM -0400, Naoya Horiguchi wrote:
> pmd_trans_unstable() in pagemap_pte_range() comes before pmd_trans_huge_lock()
> now, which means that pagewalk kicked by reading /proc/pid/pagemap does not
> run over thp. This patch fixes it.

This should be fixed already.
