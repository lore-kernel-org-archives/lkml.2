Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020Ab2C2U0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 16:26:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759841Ab2C2U0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 16:26:36 -0400
Date: Thu, 29 Mar 2012 22:26:28 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] pagemap: remove remaining unneeded spin_lock()
Message-ID: <20120329202628.GD20930@redhat.com>
References: <1333010379-31126-1-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333010379-31126-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 04:39:39AM -0400, Naoya Horiguchi wrote:
> commit: 025c5b2451e4 "thp: optimize away unnecessary page table locking"
> moves spin_lock() into pmd_trans_huge_lock() in order to avoid locking
> unless pmd is for thp. So this spin_lock() is a bug.
> 
> Reported-by: Sasha Levin <levinsasha928@gmail.com>
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
