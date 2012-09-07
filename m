Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281Ab2IGJh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 05:37:29 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42858 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab2IGJh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 05:37:28 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <2329337.9aFzn0oRxF@tux200s>
References: <2372445.fuIXicT4H0@tux200s>
	<20120907011542.GA26688@kroah.com>
	<2329337.9aFzn0oRxF@tux200s>
Date: Fri, 7 Sep 2012 11:37:27 +0200
X-Google-Sender-Auth: Y7U3YTMp7UPgBMUAgA9aOolO1o4
Message-ID: <CAKMK7uHqk1x4dM9ZA0usskNoArR6eTFmEtVw+_juzVq1NeYg+A@mail.gmail.com>
Subject: Re: Re: 3.4.10 i915 [GM45] regression
From: Daniel Vetter <daniel@ffwll.ch>
To: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 3:57 AM, Andreas Sturmlechner
<andreas.sturmlechner@gmail.com> wrote:
>> On Fri, Sep 07, 2012 at 02:27:12AM +0200, Andreas Sturmlechner wrote:
>> > Hello,
>> >
>> > please revert commit 0d8957c8a90bbb5d34fab9a304459448a5131e06 - for some
>> > reason it breaks boot-up (screen stays blank) on my GM45 hardware despite
>> > >= 3.5 being fine.
>> >
>> > See bug 54575 on freedesktop.org for a full description:
>> > https://bugs.freedesktop.org/show_bug.cgi?id=54575
>> >
>> > No idea how far-spread or not this might be since I couldn't find any
>> > other reports of that kind.
>>
>> Can you cc: this to the people who wrote that patch?  That might help in
>> figuring out what is wrong here...

drm/i915 cat-herder here - I have no idea what's going on :( Things
seem to work on 3.5, I haven't gotten any regression reports for gm45
on 3.5 (and these boxes are rather popular). And all the people who
reported issues with this patch on 3.4 had no such problems on 3.5
(with the same patch applied).

And I've looked again at the patches in that area and don't see what
could be missing. Hence I guess we should just revert this patch from
3.4.

Thanks, Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 364 57 48 - http://blog.ffwll.ch
