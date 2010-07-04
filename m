Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983Ab0GDUFd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 16:05:33 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56017 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757959Ab0GDUFc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 16:05:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QII1CEb/k3FqxDxWxZsMZ5nv2IqzYXb0Re66rwT+ZJPlqdCysDmC9lTl9BL6ntpz0B
         Z9gsEy42GXNe6/N0mlS1p3c01vGmAYYy26BFmo5pj3lVFWQunjjQySUQLZQZMhPzrjEb
         KtcVACybG7Prp5I77o+A/RSxkVpkprXJFyr3E=
MIME-Version: 1.0
In-Reply-To: <131ED6E6-9BAB-4BAC-A795-889C765C35F6@mit.edu>
References: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com>
	<20100702095815.GA6802@skynet.be>
	<AANLkTimNgjtvDYY42dm-6akRjQfkHayagQWwHSS3AQs7@mail.gmail.com>
	<20100702111029.GB6802@skynet.be>
	<AANLkTikomWNbwHT-kQOm8UsUS1xkMW69cZ-mC6d8Dj56@mail.gmail.com>
	<AANLkTinZXHi_mbmsX1HTzbMNjQx7j0rbEfTKSoz-02CF@mail.gmail.com>
	<AANLkTim9Y7m3gU-w6kHvQeXT92h11kIpM8dAVaDO12uZ@mail.gmail.com>
	<131ED6E6-9BAB-4BAC-A795-889C765C35F6@mit.edu>
Date: Mon, 5 Jul 2010 06:05:28 +1000
Message-ID: <AANLkTik4_l85UNX-6YqSbtRSOVal5EDNnYvWpLEXnedZ@mail.gmail.com>
Subject: Re: Closed source userspace graphics drivers with an open source 
	kernel component
From: Dave Airlie <airlied@gmail.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Magnus Wendt <magnus.wendt@gmail.com>, Luc Verhaegen <libv@skynet.be>,
       LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 4, 2010 at 9:03 PM, Theodore Tso <tytso@mit.edu> wrote:
>
> On Jul 4, 2010, at 3:27 AM, Dave Airlie wrote:
>
>> So its as crap as the others since the kernel space is uninteresting
>> and doesn't give you any idea how to actually use the GPU, its just a
>> slightly intelligent shim which transfers command streams and
>> interrupt to/from gpu/userspace.
>>
>> Its like having an ELF loader but no source to the compiler or linker,
>> and saying the CPU is open.
>
> We have sources to our web browsers but not to the a number of the
> various web services that the browsers talk to (GMail, AIM, Gmane,
> Yahoo Finance, Google Search, etc.).
>
> And we have the sources to the Intel wireless drivers, but not to the
> firmware, and that's not necessarily considered a horrendous thing.
>
> And we generally consider our laptops to be open even though
> we don't have access to the BIOS or the SMBIOS, which can
> interrupt the OS at any time, potentially for milliseconds at a time.
>
> So the world isn't quite as black  and white as you would make things
> out to be...
>

Oh sorry I didn't realise I was downloading the 3D driver userspace
via firefox, or it was shipping in a ROM on my board,
or was running on a separate processor, and certain companies were
rather more worried about just adhering strictly to the legal GPL than
the reasons Linus picked the GPL in the first place.

I will give that one area is less black and white, ARM GPU companies
have no markets outside of Linux, the whole derived from a previous
Windows driver is a lot more grey than it is if you are nvidia.

Dave.
