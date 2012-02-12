Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139Ab2BLHQK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 02:16:10 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43193 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab2BLHQI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 02:16:08 -0500
MIME-Version: 1.0
In-Reply-To: <1329006098-5454-1-git-send-email-andrea@betterlinux.com>
References: <1329006098-5454-1-git-send-email-andrea@betterlinux.com>
Date: Sun, 12 Feb 2012 15:16:07 +0800
Message-ID: <CAJd=RBBQFuxUC4XvS7OaajzKq1Xh0yRjY62PaceWprob26N9QA@mail.gmail.com>
Subject: Re: [RFC] [PATCH v5 0/3] fadvise: support POSIX_FADV_NOREUSE
From: Hillf Danton <dhillf@gmail.com>
To: Andrea Righi <andrea@betterlinux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrea

On Sun, Feb 12, 2012 at 8:21 AM, Andrea Righi <andrea@betterlinux.com> wrote:
[...]
>  - Some of the routines to implement the generic interval tree has been taken
>   from the x86 PAT code, that uses interval trees to keep track of PAT ranges
>   (in the future it would be interesting to convert also the x86 PAT code to
>   use the generic interval tree implementation).
>
Perhaps the tree implemented in this work could also be used in tracking
regions in mm/hugetlb.c.

Thanks
Hillf
