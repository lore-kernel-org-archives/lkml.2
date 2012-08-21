Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab2HULxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:53:14 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57837 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756988Ab2HULxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:53:12 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CA+icZUXD+oWqTKB2b_xu8UEDnX6mSs_aELaGu9UQs_U4fHaKGQ@mail.gmail.com>
References: <CA+icZUWg7qEFvAsTMb9OFKmdW7XD4op14Ps2y6PLByZRArjeLg@mail.gmail.com>
	<CA+icZUVjr6aaopVAhGRr13RLDy=epdnU30YTHOhjXmrWb2sAjA@mail.gmail.com>
	<CA+icZUXD+oWqTKB2b_xu8UEDnX6mSs_aELaGu9UQs_U4fHaKGQ@mail.gmail.com>
Date: Tue, 21 Aug 2012 13:53:10 +0200
X-Google-Sender-Auth: sPByCjQ-CVc06OFqMgL24vHXC8c
Message-ID: <CAKMK7uFr972_aC8+HojLYe+Dsa0Abo0_qkLq8mbgSQs09sXihQ@mail.gmail.com>
Subject: Re: inux-next: Tree for Aug 21 (call-trace when suspending: PM?)
From: Daniel Vetter <daniel@ffwll.ch>
To: sedat.dilek@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ingo Molnar <mingo@elte.hu>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 1:14 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Tue, Aug 21, 2012 at 1:03 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Tue, Aug 21, 2012 at 1:02 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>> On Tue, Aug 21, 2012 at 8:04 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>> Hi all,
>>>>
>>>> Changes since 20120820:
>>>>
>>>> The rr tree gained a conflict against Linus' tree.
>>>>
>>>> The tip tree still has its build failure so I used the version from
>>>> next-20120814.
>>>>
>>>> The workqueues tree gained a conflict against the hid tree.
>>>>
>>>> The drivers-x86 tree still has its build failure so I used the version
>>>> from next-20120817.
>>>>
>>>> The signal tree gained a conflict against Linus' tree.  I have still
>>>> reverted 3 commits from the signal tree at the request of the arm
>>>> maintainer.
>>>>
>>>> ----------------------------------------------------------------------------
>>>>
>>>
>>> Hi,
>>>
>>> I have compiled linux-next (next-20120821) and see the attached
>>> call-trace when suspending.
>>> Suspending did NOT work (Xorg seems to cause it) - machine came back to desktop.
>>>
>>> With yesterday's next-20120820 I haven't seen this.
>>>
>>> I am not sure what is this causing... PM, x86/sched or even VFS?
>>> Any help for debugging appreciated.
>>>
>>> I am on Ubuntu/precise AMD64 and use systemd-v43 as init-system.
>>>
>>> Regards,
>>> - Sedat -
>>
>> Forgot attachment!
>> If you don't succeed - try try try...
>>
>> - Sedat -
>
> [ CC danvet ]
>
> I have pulled in drm-intel-fixes into my local GIT tree and rebuilt
> i915 - this seems to fix the problem.
> Daniel any suggestion which patch in d-i-f did it?

Without the backtrace it's kinda hard to tell ... Also, if you can
dump a git log of the commits from -fixes that you don't yet have.
-Daniel

>
> [1] http://cgit.freedesktop.org/~danvet/drm-intel/log/?h=drm-intel-fixes



-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 364 57 48 - http://blog.ffwll.ch
