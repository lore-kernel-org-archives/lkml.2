Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab0DVBcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 21:32:25 -0400
Received: from mail-qy0-f189.google.com ([209.85.221.189]:45583 "EHLO
	mail-qy0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab0DVBcX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 21:32:23 -0400
MIME-Version: 1.0
In-Reply-To: <1271317886.32749.69.camel@laptop>
References: <20100413234902.29004.41655.stgit@bumblebee1.mtv.corp.google.com>
	 <1271317886.32749.69.camel@laptop>
Date: Wed, 21 Apr 2010 18:32:22 -0700
Message-ID: <v2v8bb80c381004211832o88258fdez8e640ad9a45d11c0@mail.gmail.com>
Subject: Re: [PATCH 0/3] [idled]: Idle Cycle Injector for power capping
From: Mike Chan <mike@android.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Salman <sqazi@google.com>, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
       linux-pm@lists.linux-foundation.org, arjan@infradead.org,
       csadler@google.com, ranjitm@google.com, kenchen@google.com,
       dawnchen@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 12:51 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-04-13 at 17:08 -0700, Salman wrote:
>> As we discussed earlier this year, Google has an implementation that it
>> would like to share.  I have finally gotten around to porting it to
>> v2.6.33 and cleaning up the interfaces.  It is provided in the following
>> messages for your review.  I realize that when we first discussed this
>> idea, a lot of ideas were presented for enhancing it.  Thanks alot for
>> your suggestions.  I haven't gotten around to implementing any of them.
>
> .33 is way too old to submit patches against.
>
> That said, I really really dislike this approach, I would much rather
> see it tie in with power aware scheduling.

I may have missed this on lkml but are there any on-going community
efforts to power aware scheduling?

-- Mike

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
