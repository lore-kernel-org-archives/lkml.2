Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab2LCNCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 08:02:35 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:60123 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab2LCNCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 08:02:34 -0500
Message-ID: <50BCA2E4.8050600@suse.cz>
Date: Mon, 03 Dec 2012 14:02:28 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, Bob Liu <lliubbo@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 0/2] kernel BUG at mm/huge_memory.c:212!
References: <50B52E17.8020205@suse.cz> <1354287821-5925-1-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1354287821-5925-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2012 04:03 PM, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> Hi Jiri,
> 
> Sorry for late answer. It took time to reproduce and debug the issue.
> 
> Could you test two patches below by thread. I expect it to fix both
> issues: put_huge_zero_page() and Bad rss-counter state.

Hi, yes, since applying the patches on the last Thu, it didn't recur.

> Kirill A. Shutemov (2):
>   thp: fix anononymous page accounting in fallback path for COW of HZP
>   thp: avoid race on multiple parallel page faults to the same page
> 
>  mm/huge_memory.c | 30 +++++++++++++++++++++++++-----
>  1 file changed, 25 insertions(+), 5 deletions(-)

thanks,
-- 
js
suse labs
