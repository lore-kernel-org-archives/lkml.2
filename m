Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab1DLWa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 18:30:59 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37112 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab1DLWax convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 18:30:53 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTinzz5TuGPAMVY39V3D0x+PgKr7eGg@mail.gmail.com>
References: <BANLkTin3gtiBk8nvsWEiJetKHq2+9HTi4w@mail.gmail.com>
	<BANLkTimJLcfsYAhV+3=-F14YZvX12-yXgA@mail.gmail.com>
	<20110412182809.GA1218@redhat.com>
	<BANLkTinb1gXcZug5ApmmrudWLY7PwxNf-A@mail.gmail.com>
	<20110412192059.GA14360@redhat.com>
	<BANLkTimJgx_x=0bpBDWaUkJgZPYs3_iwsg@mail.gmail.com>
	<BANLkTimBegMUq2fX67o2YnoATWG-NDbKgA@mail.gmail.com>
	<BANLkTikoDELrA-RtA9BLm64mfoPgdADR0Q@mail.gmail.com>
	<BANLkTi=HyK+8DhJS3db0j2fefdOjwVMN3w@mail.gmail.com>
	<BANLkTinMAGmdEDviRwZ1-mxrAAe_WK5jvg@mail.gmail.com>
	<BANLkTinjGkbBMUo7MQ2Dg2yDwQ932qJ7rQ@mail.gmail.com>
	<BANLkTikRH0q3RyP_CORXjAX34-br4pqf=A@mail.gmail.com>
	<BANLkTinp6gaPrjQF6eXk4WHa653GShDuYQ@mail.gmail.com>
	<BANLkTinzz5TuGPAMVY39V3D0x+PgKr7eGg@mail.gmail.com>
Date: Wed, 13 Apr 2011 00:30:51 +0200
Message-ID: <BANLkTimfRrFTkZqqekgs3e6OgqSc2AH9NQ@mail.gmail.com>
Subject: Re: Processes hang in an unkillable state
From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Miklos Szeredi <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 12:18 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Apr 12, 2011 at 3:16 PM, Robert Święcki <robert@swiecki.net> wrote:
>> On Wed, Apr 13, 2011 at 12:12 AM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>> On Tue, Apr 12, 2011 at 2:59 PM, Robert Święcki <robert@swiecki.net> wrote:
>>>>
>>>> Compiling now with CONFIG_OPTIMIZE_SIZE and vma dump code. Will
>>>> probably post some results tomorrow.
>>>
>>> .. and if you've added my patch to the stack growth case, hopefully
>>> there won't _be_ any results ;)
>>
>> I can, depending in whether you'd like to see vma dump results for
>> this case or not. Let me know, it's still cooooompiling :).
>
> Please do add it. Since it can take a long time to trigger, it's best
> to just try to fix this issue asap. If it never triggers, and we don't
> see any vma dumps, I won't cry.

Ok,

btw, here might be another path which hits this (at least I think so).

http://alt.swiecki.net/linux_kernel/sys_mprotect-2.6.38.txt

And, generally: here are a few deadlocks/bug_on's/ooops gathered
earlier (some fixed already) - http://alt.swiecki.net/linux_kernel/ -
I'll try to ask for fixes for them one by one, as soon as they repeat
and I have proper kdb/perf dumps.

-- 
Robert Święcki
