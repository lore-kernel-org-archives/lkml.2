Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009Ab2JSXcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 19:32:41 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34405 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113Ab2JSXcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 19:32:39 -0400
MIME-Version: 1.0
In-Reply-To: <1350687838.6017.10.camel@sbsiddha-desk.sc.intel.com>
References: <fa.1zfuXwqYK6u81uBoo3IdpawcpWw@ifi.uio.no>
	<fa.p3cpkKIGUNv0/iot3o7KT9bb98M@ifi.uio.no>
	<fa.iPHW7usT23k+cCA19L3eXEDu91Q@ifi.uio.no>
	<fa.7eOK+XcsKUWU4ZXhBj2K6znxrvc@ifi.uio.no>
	<fa.VGxfKOh1Z07X1TXm5PxMIlV4xu8@ifi.uio.no>
	<fa.eH+BpYDdp4xIWE4V+wJu6hFrVxM@ifi.uio.no>
	<b0b75b2b-961b-487a-ab03-2362c65d6972@googlegroups.com>
	<1350687838.6017.10.camel@sbsiddha-desk.sc.intel.com>
Date: Fri, 19 Oct 2012 16:32:38 -0700
X-Google-Sender-Auth: ZAQbAUM6NhtpErGU_JPo1J0m210
Message-ID: <CAE9FiQUmTnhCzvaxaHbwWbcxDrjYix91Yf8TZN6ob0W_Yz1csQ@mail.gmail.com>
Subject: Re: x2apic boot failure on recent sandy bridge system
From: Yinghai Lu <yinghai@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: rrl125@gmail.com, fa.linux.kernel@googlegroups.com,
        "Berck E. Nash" <flyboy@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 4:03 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> On Fri, 2012-10-19 at 13:42 -0700, rrl125@gmail.com wrote:
>> Any update? The messages just seem to have stopped months ago. A
>> fallback would be nice, I have been booting the kernel with noa2xpic
>> for since kernel 3.2, and currently I am working with 3.6.2.
>>
>> If needed I can try to attempt modifying the patch to include
>> fallback, but I am probably not the best person to do it.
>>
>
> Are you referring to this commit that made into the mainline tree
> already?
>
> commit fb209bd891645bb87b9618b724f0b4928e0df3de
> Author: Yinghai Lu <yinghai@kernel.org>
> Date:   Wed Dec 21 17:45:17 2011 -0800
>
>     x86, x2apic: Fallback to xapic when BIOS doesn't setup interrupt-remapping

I think his system has DMAR table and cpu support x2apic, So kernel
will switch to x2apic,

but somehow BIOS SMI handler has problem with x2apic. should be thinkpad W520?
