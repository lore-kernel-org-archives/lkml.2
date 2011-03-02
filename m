Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab1CBV2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:28:14 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34813 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679Ab1CBV2M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:28:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pjZTElXX7aTDLK/PpJTk6zwVqy2amHNeZ02DB8TMZGIiIRAAqf2cavsJMfSfTMZYMg
         32wf+okc/149mL1KXdLH0uTKPD5E46qKxdRhO8SIpYzdqPO+VntOmv1Im/HoL6fukExR
         8BmGyiQ13AgXG5adP74JIa0aRZn7dLW6P954U=
MIME-Version: 1.0
In-Reply-To: <4D6EA473.9000001@zytor.com>
References: <4D6E8932.1010405@zytor.com>
	<20110302120339.efd60504.akpm@linux-foundation.org>
	<4D6EA473.9000001@zytor.com>
Date: Wed, 2 Mar 2011 22:28:12 +0100
Message-ID: <AANLkTi=5C3-DkOGFZ3nWCgkQMWC=Va9ZoFRjyV2vxdg7@mail.gmail.com>
Subject: Re: RFC: x86: kill binutils 2.16.x?
From: Vegard Nossum <vegard.nossum@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Breeds <tony@bakeyournoodle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 March 2011 21:11, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/02/2011 12:03 PM, Andrew Morton wrote:
>> On Wed, 02 Mar 2011 10:15:14 -0800
>> "H. Peter Anvin" <hpa@zytor.com> wrote:
>>
>>> binutils 2.16 (and presumably its prereleases, binutils 2.15.9x) appears
>>> to have more bugs than any other version of binutils released in modern
>>> history, *before or after*.
>>>
>>> We chronically run into problems because that particular binutils
>>> version breaks code that works fine elsewhere.
>>>
>>> I would like to know who would suffer from formally discontinuing
>>> support for that version.  I understand some version of SLES shipped it,
>>> but I don't know for sure.
>>>
>>
>> I gave up and became a customer of
>> http://www.kernel.org/pub/tools/crosstool/index_old.shtml
>
> Vegard,
>
> The source directory in the above doesn't seem to match the binary
> directories, and is stuck at binutils 2.16.1.  At the very best this is
> iffy from a GPL perspective, and very confusing to users.
>
> This is obviously a highly useful project, can we straighten out the
> source situation?

I only uploaded the binaries in

    http://www.kernel.org/pub/tools/crosstool/files/bin/old/

which should match the sources in

    http://www.kernel.org/pub/tools/crosstool/files/src/

The binaries outside old/ are not made by me, but Tony (added to Cc).

I assume you're talking about the binaries _outside_ bin/old/, but let
me know if I'm mistaken :-)


Vegard
