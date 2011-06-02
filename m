Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab1FBXCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 19:02:37 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43637 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab1FBXCg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 19:02:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vPUd/qi2sttEUM+9uczK+daWZOSjWGk6bcoQJqd9T2qb9FfXkU92MaBvuOzbxZP4u6
         FAV+76L/NRnalhcWxe82esHGBCg78CDML1ABWUOa8SR8AORRwsqM2lBDa6XwxO6Qg6vI
         55uJuo3GMApriW0eV7ktAAiTZMpU67lATxzvA=
MIME-Version: 1.0
In-Reply-To: <20110602182302.GA2802@random.random>
References: <20110530143109.GH19505@random.random>
	<20110530153748.GS5044@csn.ul.ie>
	<20110530165546.GC5118@suse.de>
	<20110530175334.GI19505@random.random>
	<20110531121620.GA3490@barrios-laptop>
	<20110531122437.GJ19505@random.random>
	<20110531133340.GB3490@barrios-laptop>
	<20110531141402.GK19505@random.random>
	<20110531143734.GB13418@barrios-laptop>
	<20110531143830.GC13418@barrios-laptop>
	<20110602182302.GA2802@random.random>
Date: Fri, 3 Jun 2011 08:02:35 +0900
Message-ID: <BANLkTi=d9q+W2LBiMYr0ND6XqSWGX3gMKg@mail.gmail.com>
Subject: Re: [PATCH] mm: compaction: Abort compaction if too many pages are
 isolated and caller is asynchronous
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Mel Gorman <mel@csn.ul.ie>,
        akpm@linux-foundation.org, Ury Stankevich <urykhy@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 3:23 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> On Tue, May 31, 2011 at 11:38:30PM +0900, Minchan Kim wrote:
>> > Yes. You find a new BUG.
>> > It seems to be related to this problem but it should be solved although
>>
>>  typo : It doesn't seem to be.
>
> This should fix it, but I doubt it matters for this problem.
>
> ===
> Subject: mm: no page_count without a page pin
>
> From: Andrea Arcangeli <aarcange@redhat.com>
>
> It's unsafe to run page_count during the physical pfn scan.
>
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Nitpick :
I want to remain "  /* the page is freed already. */" comment.

-- 
Kind regards,
Minchan Kim
