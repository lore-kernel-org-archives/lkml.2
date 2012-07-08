Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab2GHC3O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 22:29:14 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58690 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2GHC3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 22:29:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120707003819.GA2041@barrios>
References: <1341588521-17744-1-git-send-email-js1304@gmail.com>
	<20120706155920.GA7721@barrios>
	<CAAmzW4N+-xS65-NDJF2V9nzGDBTFC=20sZ8LJx5wCZ8=t7SpTQ@mail.gmail.com>
	<20120707003819.GA2041@barrios>
Date: Sun, 8 Jul 2012 11:29:13 +0900
Message-ID: <CAAmzW4OzJta03PhhRgJZrbqnwrSjVoCdpx+HBQ9wzwfKi7PFDQ@mail.gmail.com>
Subject: Re: [PATCH] mm: don't invoke __alloc_pages_direct_compact when order 0
From: JoonSoo Kim <js1304@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> >> And in almost invoking case, order is 0, so return immediately.
>> >
>> > You can't make sure it.
>>
>> Okay.
>>
>> >>
>> >> Let's not invoke it when order 0
>> >
>> > Let's not ruin git blame.
>>
>> Hmm...
>> When I do git blame, I can't find anything related to this.
>
> I mean if we merge the pointless patch, it could be showed firstly instead of
> meaningful patch when we do git blame. It makes us bothering when we find blame-patch.

Oh... I see.

Thanks for comments.
