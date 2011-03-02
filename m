Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab1CBV3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:29:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57854 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281Ab1CBV3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:29:49 -0500
Message-ID: <4D6EB6A8.6090808@zytor.com>
Date: Wed, 02 Mar 2011 13:29:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Breeds <tony@bakeyournoodle.com>
Subject: Re: RFC: x86: kill binutils 2.16.x?
References: <4D6E8932.1010405@zytor.com>	<20110302120339.efd60504.akpm@linux-foundation.org>	<4D6EA473.9000001@zytor.com> <AANLkTi=5C3-DkOGFZ3nWCgkQMWC=Va9ZoFRjyV2vxdg7@mail.gmail.com>
In-Reply-To: <AANLkTi=5C3-DkOGFZ3nWCgkQMWC=Va9ZoFRjyV2vxdg7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2011 01:28 PM, Vegard Nossum wrote:
> On 2 March 2011 21:11, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 03/02/2011 12:03 PM, Andrew Morton wrote:
>>> On Wed, 02 Mar 2011 10:15:14 -0800
>>> "H. Peter Anvin" <hpa@zytor.com> wrote:
>>>
>>>> binutils 2.16 (and presumably its prereleases, binutils 2.15.9x) appears
>>>> to have more bugs than any other version of binutils released in modern
>>>> history, *before or after*.
>>>>
>>>> We chronically run into problems because that particular binutils
>>>> version breaks code that works fine elsewhere.
>>>>
>>>> I would like to know who would suffer from formally discontinuing
>>>> support for that version.  I understand some version of SLES shipped it,
>>>> but I don't know for sure.
>>>>
>>>
>>> I gave up and became a customer of
>>> http://www.kernel.org/pub/tools/crosstool/index_old.shtml
>>
>> Vegard,
>>
>> The source directory in the above doesn't seem to match the binary
>> directories, and is stuck at binutils 2.16.1.  At the very best this is
>> iffy from a GPL perspective, and very confusing to users.
>>
>> This is obviously a highly useful project, can we straighten out the
>> source situation?
> 
> I only uploaded the binaries in
> 
>     http://www.kernel.org/pub/tools/crosstool/files/bin/old/
> 
> which should match the sources in
> 
>     http://www.kernel.org/pub/tools/crosstool/files/src/
> 
> The binaries outside old/ are not made by me, but Tony (added to Cc).
> 
> I assume you're talking about the binaries _outside_ bin/old/, but let
> me know if I'm mistaken :-)
> 

Sorry, you're right... I got confused because the index file is still
the old one...

	-hpa
