Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab1AJPjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 10:39:43 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62856 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab1AJPjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 10:39:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=m+Z/ftUCniD411V5jl2Fwc7ykSuyqs0JrkW2ulpYBPnycCnqfdIUi0pbFF1433+YG+
         9BG6cWrwfTOjMRqjVnJdwB/xEyRfTEtOUIK2mSaddegMhsw/dvr9KNzx/kUdXYSsqszq
         SCSt1+CXTcVPFB7tmG4fuAC241V94ocrGt7mc=
MIME-Version: 1.0
In-Reply-To: <20110106095647.GC29257@csn.ul.ie>
References: <cover.1292604745.git.minchan.kim@gmail.com>
	<08549e97645f7d6c2bcc5c760a24fde56dfed513.1292604745.git.minchan.kim@gmail.com>
	<20110106095647.GC29257@csn.ul.ie>
Date: Tue, 11 Jan 2011 00:39:39 +0900
Message-ID: <AANLkTin9RhCSf4YO2KYujV7T3W7D3vuecmGOq7XvFQGn@mail.gmail.com>
Subject: Re: [RFC 3/5] tlbfs: Remove unnecessary page release
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        William Irwin <wli@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 6:56 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Sat, Dec 18, 2010 at 02:13:38AM +0900, Minchan Kim wrote:
>> This patch series changes remove_from_page_cache's page ref counting
>> rule. page cache ref count is decreased in remove_from_page_cache.
>> So we don't need call again in caller context.
>>
>> Cc: William Irwin <wli@holomorphy.com>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>
> Other than the subject calling hugetlbfs tlbfs, I did not see any problem
> with this assuming the first patch of the series is also applied.

Thanks, Mel.
Will fix.


-- 
Kind regards,
Minchan Kim
