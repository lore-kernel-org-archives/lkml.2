Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab1HLTOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 15:14:06 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:37348 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab1HLTOD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 15:14:03 -0400
MIME-Version: 1.0
In-Reply-To: <m24o1mmqr8.fsf_-_@firstfloor.org>
References: <cover.1312899174.git.luto@mit.edu> <066852f3f344c1733e0db9a2427981ea1815db7d.1312899174.git.luto@mit.edu>
 <m24o1mmqr8.fsf_-_@firstfloor.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 12 Aug 2011 15:13:42 -0400
X-Google-Sender-Auth: 0HviZMsW0ozfjbIQyRprrgDMs08
Message-ID: <CAObL_7HCqoBT_YY+mtb7wcAAHd1pxuACp8kZ62M47KAqjzLHNQ@mail.gmail.com>
Subject: Re: NACK! Re: [PATCH 4/4] Add vsyscalls to feature-removal-schedule.txt
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@alien8.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 2:25 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Andy Lutomirski <luto@MIT.EDU> writes:
>
>> In a couple years, we'll see how well we've done at eradicating vsyscall-using
>> binaries.  Hopefully we can then disable them by default.  We will probably
>> have to leave the option to enable them around forever.
>
> NACK NACK NACK!
>

It's already dropped from the version in tip/x86/vdso.

> this would break all old (old = meaning all today's) x86-64 installations.

Somewhat to my surprise, fully up-to-date Fedora 15 seems to work fine
with vsyscall=none, and I wouldn't be terribly surprised if a few of
the distributions starting making it the default sooner or later.  I
might do a followup patch to make the switch betweeen vsyscall=emulate
and vsyscall=none work as a sysctl.  (Switching from native to emulate
at runtime could be problematic.)

--Andy
