Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab2LDJkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 04:40:13 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38956 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab2LDJkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 04:40:09 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CAPM=9twQZUWBf9FZdAwz5NuaTvfgJSA=bjgHq9rpTMMU3ABRVw@mail.gmail.com>
References: <20121203173951.GA25384@fancy-poultry.org>
	<CAHdPZaP6HvM=UqkAjyC8MFMv9ZFTyxjx-CsMQ+8QZaxPCaW1Hw@mail.gmail.com>
	<20121204083655.GA21235@fancy-poultry.org>
	<CAPM=9twQZUWBf9FZdAwz5NuaTvfgJSA=bjgHq9rpTMMU3ABRVw@mail.gmail.com>
Date: Tue, 4 Dec 2012 10:40:07 +0100
X-Google-Sender-Auth: n0KJCSV5R8L6X8Cp8cYoejsioIQ
Message-ID: <CAKMK7uEGTWgPO-wf7aNLC+y9zLYPyy6f_djn6D-Gx-n6bFqcJA@mail.gmail.com>
Subject: Re: i915 freakout with latest 3.7 git
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Heinz Diehl <htd@fancy-poultry.org>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 4, 2012 at 10:27 AM, Dave Airlie <airlied@gmail.com> wrote:
> On Tue, Dec 4, 2012 at 6:36 PM, Heinz Diehl <htd@fancy-poultry.org> wrote:
>> On 03.12.2012, devendra.aaru wrote:
>>
>>> Add more CC's
>>
>> Thanks!
>>
>> This is a real showstopper for me, it occurs in every session now.
>> Booting with "i915.i915_enable_rc6=0" doesn't help
>
> https://bugs.freedesktop.org/show_bug.cgi?id=55984
>
> intel guys are as lost as anyone.

Yeah, if anyone can somewhat reliably reproduce this (you need to
disable rc6 on ilk to not hit another issue which seems much easier to
hit) and bisect it, this would be _very_ much appreciated - we've
pretty much tested all possible "disable stuff" and "revert random
patch" we could thing of, and we can't reproduce these hangs no matter
how hard we bang our heads against this. Atm we're trying to come up
with ways to dump more debug information, but with no clue whatsoever
what's going on that's slow-going.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
