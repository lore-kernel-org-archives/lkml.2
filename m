Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab2DDMWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 08:22:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51119 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756281Ab2DDMWp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 08:22:45 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1204032348470.3865@chino.kir.corp.google.com>
References: <4EE6F24B.7050204@gmail.com>
	<alpine.DEB.2.00.1203071331150.15255@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1204032348470.3865@chino.kir.corp.google.com>
Date: Wed, 4 Apr 2012 20:22:45 +0800
Message-ID: <CAJd=RBB0+TpK6Y+VrWgisAJ9J0xOOCYuuFo2vBTw-i2Huj4uKw@mail.gmail.com>
Subject: Re: [PATCH] mm/hugetlb.c: cleanup to use long vars instead of int in region_count
From: Hillf Danton <dhillf@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Wang Sheng-Hui <shhuiw@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 4, 2012 at 2:49 PM, David Rientjes <rientjes@google.com> wrote:
> On Wed, 7 Mar 2012, David Rientjes wrote:
>
>> On Tue, 13 Dec 2011, Wang Sheng-Hui wrote:
>>
>> > args f & t and fields from & to of struct file_region are defined
>> > as long. Use long instead of int to type the temp vars.
>> >
>> > Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
>> > ---
>> >  mm/hugetlb.c |    4 ++--
>> >  1 files changed, 2 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> > index dae27ba..e666287 100644
>> > --- a/mm/hugetlb.c
>> > +++ b/mm/hugetlb.c
>> > @@ -195,8 +195,8 @@ static long region_count(struct list_head *head, long f, long t)
>> >
>> >     /* Locate each segment we overlap with, and count that overlap. */
>> >     list_for_each_entry(rg, head, link) {
>> > -           int seg_from;
>> > -           int seg_to;
>> > +           long seg_from;
>> > +           long seg_to;
>> >
>> >             if (rg->to <= f)
>> >                     continue;
>>
>> Acked-by: David Rientjes <rientjes@google.com>
>>

Acked-by: Hillf Danton <dhillf@gmail.com>
