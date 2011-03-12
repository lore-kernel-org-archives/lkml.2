Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab1CLFfa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 00:35:30 -0500
Received: from smtp-out.google.com ([74.125.121.67]:9403 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab1CLFf2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 00:35:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=tBe4/QPd0Y2dBh2YvaHpy+e8BpmsvInkZOFSUUKEpQjlF5oiFV937V9ts8h0jI+K1T
         o48m3SWPw2yvpTOjdZhA==
MIME-Version: 1.0
In-Reply-To: <20110312041729.GB15526@home.goodmis.org>
References: <1299877572-30353-1-git-send-email-teravest@google.com> <20110312041729.GB15526@home.goodmis.org>
From: Justin TerAvest <teravest@google.com>
Date: Fri, 11 Mar 2011 21:35:04 -0800
Message-ID: <AANLkTi=Jo_bPiZDg0uYgN+scH1m=G59GQzbuMTZeeFyO@mail.gmail.com>
Subject: Re: [PATCH] Add unaccounted time to timeslice_used.
To: Steven Rostedt <rostedt@goodmis.org>
Cc: jaxboe@fusionio.com, vgoyal@redhat.com, ctalbott@google.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 8:17 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, Mar 11, 2011 at 01:06:12PM -0800, Justin TerAvest wrote:
>> There are two kind of times that tasks are not charged for: the first
>> seek and the extra time slice used over the allocated timeslice. Both
>> of these exported as a new unaccounted_time stat.
>>
>> I think it would be good to have this reported in 'time' as well, but
>> that is probably a separate discussion.
>>
>> Signed-off-by: Justin TerAvest <teravest@google.com>
>> ---
>>  block/blk-cgroup.c  |   16 +++++++++++++++-
>>  block/blk-cgroup.h  |   12 ++++++++++--
>>  block/cfq-iosched.c |   21 +++++++++++++--------
>>  block/cfq.h         |    6 +++---
>>  4 files changed, 41 insertions(+), 14 deletions(-)
>
> Hi! Just an FYI, could you add what subsystem you are changing into the
> subject. Like:
>
> [PATCH] block: Add unaccounted time to timeslice_used
>
> Otherwise, the subject looks like it's modifying the kernel internal time
> source.

Sorry about that. I'll be more careful in the future.

Thanks,
Justin

>
> Thanks,
>
> -- Steve
>
>
