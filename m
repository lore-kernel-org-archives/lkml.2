Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab2IFO37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:29:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38092 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab2IFO36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:29:58 -0400
MIME-Version: 1.0
In-Reply-To: <1346773188.27919.13.camel@gandalf.local.home>
References: <1346091725.19381.10.camel@pippen.local.home>
	<CAM_iQpV9163UKQt8Kvroc6JyMQnv1tqG1rS5M2CBWzbo7XvJXQ@mail.gmail.com>
	<1346773188.27919.13.camel@gandalf.local.home>
Date: Thu, 6 Sep 2012 22:29:58 +0800
Message-ID: <CAM_iQpUHYDT2hnt3h8fF33rp3O9c_VjEftOFUj-qdMdUkxo1tw@mail.gmail.com>
Subject: Re: [PATCH] Add feature-removal-schedule.txt removal to feature-removal-schedule.txt
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 4, 2012 at 11:39 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2012-08-29 at 09:28 +0800, Cong Wang wrote:
>> On Tue, Aug 28, 2012 at 2:22 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> > The file feature-removal-schedule.txt is ignored by most people except
>> > for people that add to it. It's more of a global TODO list for
>> > developers than being anything useful by anyone.
>> >
>> > Add a feature removal of removing the feature-removal-schedule.txt.
>> >
>>
>> Hi, Steven,
>>
>> I sometimes remind people to remove features scheduled in this file,
>> by sending a proposed patch. ;)
>
> At Kernel Summit, Linus went on a rant about this file. He said he hates
> it and is totally useless. Basically, it is only used by us developers,
> and is not used by normal users. As it is a dumping ground for all
> developers, this file becomes the biggest conflict during merges that
> Linus does.
>
> There are better ways to tell users something is about to go away. My
> preference is a nasty WARN_ON_ONCE() in the code when the feature is
> used. People tend to report call traces, and you can either tell the
> person, "don't use this" or you know that it is something that is
> actually used and you can't remove it.
>

I don't think feature-removal-schedule.txt is for kernel users, it
is a kind of a TODO list for kernel developers.
