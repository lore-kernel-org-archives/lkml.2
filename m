Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab2JIAhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 20:37:24 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:43794 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab2JIAhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 20:37:21 -0400
Message-id: <507371DA.9080309@samsung.com>
Date: Tue, 09 Oct 2012 02:37:46 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907
 Thunderbird/15.0.1
MIME-version: 1.0
To: Rabin Vincent <rabin@rab.in>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: CMA and zone watermarks
References: <CAH+eYFCJTtF+FeqKs_ho5yyX0tkUBoaa-yfsd1rVshcQ5Xxp=A@mail.gmail.com>
In-reply-to: <CAH+eYFCJTtF+FeqKs_ho5yyX0tkUBoaa-yfsd1rVshcQ5Xxp=A@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/8/2012 5:41 PM, Rabin Vincent wrote:

> It appears that when CMA is enabled, the zone watermarks are not properly
> respected, leading to for example GFP_NOWAIT allocations getting access to the
> high pools.
>
> I ran the following test code which simply allocates pages with GFP_NOWAIT
> until it fails, and then tries GFP_ATOMIC.  Without CMA, the GFP_ATOMIC
> allocation succeeds, with CMA, it fails too.

Could You run your test with latest linux-next kernel? There have been 
some patches merged to akpm tree which should fix accounting for free 
and free cma pages. I hope it should fix this issue.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center
