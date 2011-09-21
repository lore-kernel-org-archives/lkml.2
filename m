Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751133Ab1IUU4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 16:56:18 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:48355 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab1IUU4O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 16:56:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAC7LmnuOieBzq=833UOjbdPfdjQaHWou_keu0_coZ-KCFJ2kaw@mail.gmail.com>
References: <yun8vppw9lu.fsf@aiko.keithp.com>
	<CAC7LmnuOieBzq=833UOjbdPfdjQaHWou_keu0_coZ-KCFJ2kaw@mail.gmail.com>
Date: Wed, 21 Sep 2011 16:56:12 -0400
Message-ID: <CAOJpy9v=7GZgmEQesL5za9_xhrbgHwNJhhg9cTxVVWWA4fEV2w@mail.gmail.com>
Subject: Re: Whitespace cleanups in drm/i915
From: Akshay Joshi <me@akshayjoshi.com>
To: Eugeni Dodonov <eugeni@dodonov.net>
Cc: Keith Packard <keithp@keithp.com>, airlied@gmail.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 17, 2011 at 4:17 PM, Eugeni Dodonov <eugeni@dodonov.net> wrote:
> On Thu, Sep 15, 2011 at 22:37, Keith Packard <keithp@keithp.com> wrote:
>>
>> I've got this nice patch from Akshay Joshi that removes almost all of
>> the checkpatch.pl warnings from drm/i915. If I don't merge it now, it's
>> going to go stale and be useless; if I merge it only to drm-intel-next,
>> it will be the source of endless conflicts.
>>
>> However, it's a huge patch (yes, the code was rather sloppy), and
>> doesn't exactly fit into the "critical patches only please" mode of the
>> current stage of 3.1 development.
>>
>> I've checked the patch very carefully, using the obvious git diff -b to
>> make sure it really doesn't touch anything but whitespace, but also
>> using objdump -s to compare the output of the compiler. There were no
>> differences found with git-diff -b. The only differences found by
>> objdump are two whitespace changes in some debug output messages in
>> intel_bios.c.
>>
>> I think I have three choices:
>>
>>  1) merge the patch and expect complaints from upstream
>>
>>  2) thank Akshay for his good intentions, discard the patch and hope
>>    that he feels motivated enough to do it all over again in time for
>>    the 3.2 merge window.
>>
>>  3) thank Akshay for his good intentions and leave the code as-is,
>>    forever to ease back-porting of fixes to older kernel versions.
>>
>> Frankly, if we're ever going to merge whitespace fixups, this would be a
>> pretty darn good time; drm-intel-fixes and drm-intel-next are in-sync as
>> I haven't started pulling 3.2 code into -next.
>
> I think that if we don´t get to push this patch now, we are unlikely to do
> it in nearby future. And such kind of cleanup is a nice thing to have.
> So I´d vote for option 1, and then 3, in this order.
> --
> Eugeni Dodonov
>
>

Have we reached a consensus on this? Just curious.

Akshay
