Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0DSRUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 13:20:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:60965 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab0DSRUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 13:20:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=oCpSYk0le292q3ka9j/wUNLkDmUo2k1m5qT2rPLyqxA1nbeXulSINyHiVk8FlYA+T
	3ykb7pOBfwOpb6HS4gi/g==
MIME-Version: 1.0
In-Reply-To: <1271317886.32749.69.camel@laptop>
References: <20100413234902.29004.41655.stgit@bumblebee1.mtv.corp.google.com>
	 <1271317886.32749.69.camel@laptop>
Date: Mon, 19 Apr 2010 10:20:01 -0700
Message-ID: <h2u4352991a1004191020q8200399oc8e9f7d8dee934bf@mail.gmail.com>
Subject: Re: [PATCH 0/3] [idled]: Idle Cycle Injector for power capping
From: Salman Qazi <sqazi@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       svaidy@linux.vnet.ibm.com, linux-pm@lists.linux-foundation.org,
       arjan@infradead.org, csadler@google.com, ranjitm@google.com,
       kenchen@google.com, dawnchen@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
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

Will bump up the version when I refresh the change.

>
> That said, I really really dislike this approach, I would much rather
> see it tie in with power aware scheduling.

I think I can see your point:  there is potentially better information
about the power consumption of the CPU beyond the time it was busy.
But please clarify: is your complaint the lack of use of this
information or are you arguing for a deeper integration into the
scheduler (I.e. implementing it as part of the scheduler rather than
an independent thread) or both?

>
>
