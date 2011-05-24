Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab1EXOUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:20:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46061 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471Ab1EXOUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:20:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xpamNIA47B34H8TBlDtSBelvWKUasMpsy2fUTZ0HUOKtlv+L8R5VuxRa2fp44pTj16
         tbVgt9OMYjlfTF/ggy63B1UjUeCyN6oJYj20fAhAM5iuZb+Ojfk/lcd67MKKW4AQ9OP5
         9Wa3Tqb3qhhqNk0e8KEkWaYH2ZSPMzP9ErDmU=
MIME-Version: 1.0
In-Reply-To: <1306238014.16375.0.camel@marge.simson.net>
References: <BANLkTimxmWiof9s5AvS3v_0X+sMiE=0x5g@mail.gmail.com>
	<BANLkTikhvhptDG-eRZ9uD5wSm3RxTn1RFw@mail.gmail.com>
	<1306238014.16375.0.camel@marge.simson.net>
Date: Tue, 24 May 2011 22:20:20 +0800
Message-ID: <BANLkTimq31hMRa+vD=pLrtTAx=Hv=h0Acg@mail.gmail.com>
Subject: Re: [PATCH] sched: remove noop in next_prio()
From: Hillf Danton <dhillf@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Yong Zhang <yong.zhang0@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 7:53 PM, Mike Galbraith <efault@gmx.de> wrote:
> On Tue, 2011-05-24 at 16:17 +0800, Yong Zhang wrote:
>> On Sat, May 21, 2011 at 10:19 PM, Hillf Danton <dhillf@gmail.com> wrote:
>> > When computing the next priority for a given run-queue, the check for
>> > RT priority of the task determined by the pick_next_highest_task_rt()
>> > function could be removed, since only RT task is returned by the
>> > function.
>> >
>> > Signed-off-by: Hillf Danton <dhillf@gmail.com>
>>
>> Yup, it's true.
>
> (could whack the else while there)
>

Where is it, Mike?

thanks
           Hillf
