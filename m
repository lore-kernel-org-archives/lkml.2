Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab1JUDB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 23:01:58 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56363 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab1JUDB5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 23:01:57 -0400
MIME-Version: 1.0
In-Reply-To: <yun4nzllamt.fsf@aiko.keithp.com>
References: <CA+i8gK+H4Y=+ZMr9QHh-1mn0wEdhDzf4iSqUgD322UhyXoruCg@mail.gmail.com>
	<yun4nzllamt.fsf@aiko.keithp.com>
Date: Fri, 21 Oct 2011 10:01:57 +0700
Message-ID: <CA+i8gKK5wuR3zo0d4Mz6pZjFUhdj4mmW+TvVg+rWrBR2eCOOEw@mail.gmail.com>
Subject: Re: [GIT BISECT] 2c1756b12edc19fdd75c833699cb752e1bbb641e - Display
 corruption after blank screen state
From: Emmanuel Benisty <benisty.e@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 7, 2011 at 10:54 AM, Keith Packard <keithp@keithp.com> wrote:
> On Wed, 7 Sep 2011 23:33:13 +0700, Emmanuel Benisty <benisty.e@gmail.com> wrote:
>
> (I'm sorry I missed this mail; I was preoccupied with family issues
> that week).

And I missed your reply too, very sorry about this.

>> The following commit causes display corruption once the machine goes
>> out from default X server power saving blank screen state. This is
>> with an i3 330m.
>
> Can you provide more information about which display is corrupted and
> what the corruption looks like?
>
>> commit 2c1756b12edc19fdd75c833699cb752e1bbb641e
>> Merge: cf96e46 d74362c
>> Author: Keith Packard <keithp@keithp.com>
>> Date:   Thu Jul 28 16:30:41 2011 -0700
>>
>>     Merge branch 'drm-intel-fixes' into drm-intel-next
>>
>
> Can you provide the output of intel_reg_dumper from both working and
> non-working kernels? Reverting this merge would be a fairly substantial
> challenge at this point in the release cycle, so I'd like to see if we
> can't narrow things down a bit and find the actual code change at fault.

This is now fixed in Linus' tree. Just FTR, adding
i915.i915_enable_fbc=0 solved the issue (prior to mainline fix).
