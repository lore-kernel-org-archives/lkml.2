Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab0KWHQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 02:16:59 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37359 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab0KWHQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 02:16:58 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ben Gamari <bgamari@gmail.com>
Subject: Re: [RFC 1/2] deactive invalidated pages
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
In-Reply-To: <874obawvlt.fsf@gmail.com>
References: <bdd6628e81c06f6871983c971d91160fca3f8b5e.1290349672.git.minchan.kim@gmail.com> <874obawvlt.fsf@gmail.com>
Message-Id: <20101122103756.E236.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 23 Nov 2010 16:16:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 21 Nov 2010 23:30:23 +0900, Minchan Kim <minchan.kim@gmail.com> wrote:
> > 
> > Ben, Remain thing is to modify rsync and use
> > fadvise(POSIX_FADV_DONTNEED). Could you test it?
> 
> Thanks a ton for the patch. Looks good. Testing as we speak.

If possible, can you please post your rsync patch and your testcase
(or your rsync option + system memory size info + data size info)?



