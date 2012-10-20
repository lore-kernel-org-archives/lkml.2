Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135Ab2JTAlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 20:41:52 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36495 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab2JTAlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 20:41:51 -0400
MIME-Version: 1.0
In-Reply-To: <1350691333.6017.23.camel@sbsiddha-desk.sc.intel.com>
References: <fa.1zfuXwqYK6u81uBoo3IdpawcpWw@ifi.uio.no>
	<fa.p3cpkKIGUNv0/iot3o7KT9bb98M@ifi.uio.no>
	<fa.iPHW7usT23k+cCA19L3eXEDu91Q@ifi.uio.no>
	<fa.7eOK+XcsKUWU4ZXhBj2K6znxrvc@ifi.uio.no>
	<fa.VGxfKOh1Z07X1TXm5PxMIlV4xu8@ifi.uio.no>
	<fa.eH+BpYDdp4xIWE4V+wJu6hFrVxM@ifi.uio.no>
	<b0b75b2b-961b-487a-ab03-2362c65d6972@googlegroups.com>
	<1350687838.6017.10.camel@sbsiddha-desk.sc.intel.com>
	<CAE9FiQUmTnhCzvaxaHbwWbcxDrjYix91Yf8TZN6ob0W_Yz1csQ@mail.gmail.com>
	<5081E414.6080004@zytor.com>
	<1350691333.6017.23.camel@sbsiddha-desk.sc.intel.com>
Date: Fri, 19 Oct 2012 17:41:49 -0700
X-Google-Sender-Auth: Tmr3ab7pjXT8EQyReDUY-C4MJOY
Message-ID: <CAE9FiQWFqo89oe30broBU5mwPoxudkVhVrUiY+3+HL9Kp0fvSw@mail.gmail.com>
Subject: Re: x2apic boot failure on recent sandy bridge system
From: Yinghai Lu <yinghai@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, rrl125@gmail.com,
        fa.linux.kernel@googlegroups.com, "Berck E. Nash" <flyboy@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 5:02 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> On Fri, 2012-10-19 at 16:36 -0700, H. Peter Anvin wrote:
>> On 10/19/2012 04:32 PM, Yinghai Lu wrote:
>> > On Fri, Oct 19, 2012 at 4:03 PM, Suresh Siddha
>> > <suresh.b.siddha@intel.com> wrote:
>> >> On Fri, 2012-10-19 at 13:42 -0700, rrl125@gmail.com wrote:
>> >>> Any update? The messages just seem to have stopped months ago. A
>> >>> fallback would be nice, I have been booting the kernel with noa2xpic
>> >>> for since kernel 3.2, and currently I am working with 3.6.2.
>> >>>
>> >>> If needed I can try to attempt modifying the patch to include
>> >>> fallback, but I am probably not the best person to do it.
>> >>>
>> >>
>> >> Are you referring to this commit that made into the mainline tree
>> >> already?
>> >>
>> >> commit fb209bd891645bb87b9618b724f0b4928e0df3de
>> >> Author: Yinghai Lu <yinghai@kernel.org>
>> >> Date:   Wed Dec 21 17:45:17 2011 -0800
>> >>
>> >>      x86, x2apic: Fallback to xapic when BIOS doesn't setup interrupt-remapping
>> >
>> > I think his system has DMAR table and cpu support x2apic, So kernel
>> > will switch to x2apic,
>> >
>> > but somehow BIOS SMI handler has problem with x2apic. should be thinkpad W520?
>> >
>>
>> Right, StinkPad W520 needs a quirk.
>
> yes. Yinghai, if you remember you had a T420 that didn't show the
> problem. And someone in the bugzilla with T420 had the problem. And
> their dmidecode is
> https://launchpadlibrarian.net/109393850/dmidecode.txt
>
> What is the difference with your system? Bios I think is the same.

1.37 was working too, i updated it to 1.39 and it is still working.

>
> Can you see what we should check for in the dmi tables to black list
> these systems? Can you post your T420's dmidecode to see the difference.
>
> https://bugzilla.kernel.org/show_bug.cgi?id=43054

post dmesg and dmidecode to that bug report.

Thanks

Yinghai
