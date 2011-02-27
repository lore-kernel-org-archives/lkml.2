Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab1B0Xo2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 18:44:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50458 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab1B0XoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 18:44:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH] fs/locks.c: Remove stale FIXME left over from BKL conversion
Date: Sun, 27 Feb 2011 18:11:07 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Matthew Wilcox <willy@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1298815080-25733-1-git-send-email-matt@console-pimps.org>
In-Reply-To: <1298815080-25733-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102271811.07449.arnd@arndb.de>
X-Provags-ID: V02:K0:JNquQ7BIgf/ZdFQqEoFFFrAuk9mbvs5Je7j5efzyqZI
 m7/LpsiI8XvUxT2s/2STzrtyhCSGD7BYRV+aYnUIsVZbxV/t0x
 fvaIxQebxdR8dAaY2WCvtGoiptyBIO3eUAMucyntbUxZ9t7HwF
 0PqwYedgCaI2iqrfQG2wnCgwC3ZLjl7r9LEujSBjAMDTSnLp9c
 XQeNXTEyQz1cZ9Yb/WBhg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 February 2011, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@linux.intel.com>
> 
> The comment is no longer true as (now that the BKL conversion is
> finished) a spinlock _is_ now used to protect file_lock_list,
> blocked_list and inode->i_flock.
> 
> Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

in case anyone wants to pick it up.

Otherwise I'll queue it along with my BKL removal patches.

Thanks,

	Arnd

