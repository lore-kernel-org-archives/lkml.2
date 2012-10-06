Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab2JFHn6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 03:43:58 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45677 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab2JFHn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 03:43:57 -0400
MIME-Version: 1.0
In-Reply-To: <20121006072704.GA22465@1wt.eu>
References: <20121005234218.GC21163@1wt.eu>
	<CAPM=9txTo4agvvFnY8KbF82WoCxh0Pmb1HcoEP4ZUbauL5Ws8Q@mail.gmail.com>
	<20121005235845.GE21163@1wt.eu>
	<20121006072704.GA22465@1wt.eu>
Date: Sat, 6 Oct 2012 03:43:56 -0400
Message-ID: <CAPM=9twQb7BUe6cAD-5THBBP-eYAU56__V5UXNn2qfqdFkVwmA@mail.gmail.com>
Subject: Re: 3.5 regression on i915
From: Dave Airlie <airlied@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 6, 2012 at 3:27 AM, Willy Tarreau <w@1wt.eu> wrote:
> On Sat, Oct 06, 2012 at 01:58:45AM +0200, Willy Tarreau wrote:
>> On Sat, Oct 06, 2012 at 09:48:57AM +1000, Dave Airlie wrote:
>> > Any reason you don't have KMS, you'll keep hitting these non-kms bugs
>> > since it has no users anymore really.
>> >
>> > Granted they'll get fixed, but I suspect its a losing battle over time.
>>
>> Well, back in old times every time I tried to enable it, I only ran into
>> problems so I got used to disable it, which made sense since it didn't
>> bring me any benefit.
>
> OK I found why in the end. When I enable KMS, my X server fails to start
> and segfaults in intel_drv.so. So I think that the comment in Kconfig
> below is quite appropriate :

Okay are you running a really old userspace? just wondering what could
cause this.

Dave.
