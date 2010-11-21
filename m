Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab0KUBGi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 20:06:38 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58206 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371Ab0KUBGg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 20:06:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FdKm4+Qr4uYdCrkyKvqZRF7ImFhAUeN2yRDlKYgjZ5aqc4HKXUfKC0juIh+faM+Rgp
         oQvXL/bvbJmLuzX8noTkYZn5Jt7uwVP3KWo3Vutb9F+5XBGz3cAxJCj/BVny0d4p1VFN
         4nTZdpVTH4iPWnfaKLgOEUv4Y2h7X34J85XF4=
MIME-Version: 1.0
In-Reply-To: <AANLkTimvf8t5Rti73kYKV9cG3d7d7Y=OCn57LQNzUuTR@mail.gmail.com>
References: <1290154233-28695-1-git-send-email-ying.huang@intel.com>
	<AANLkTin_SyFFP_2=pKoS+8+4V1qXVWyrus7BKz8ENVsJ@mail.gmail.com>
	<AANLkTincYS7G1yb2ukT67qvpjwQmptXzQZabLQLYrEqn@mail.gmail.com>
	<AANLkTi=U7F7MS48dC=GgGqh=cm8YrtVhrm6sDXOma6Fc@mail.gmail.com>
	<AANLkTiki3d3Ft3-XJwFg8DUzUYcz3xPoYTzLZokLf+dv@mail.gmail.com>
	<AANLkTinAZgHbexU+LTUZHs-+7C0N990=kyuO-USV1Ncp@mail.gmail.com>
	<AANLkTinBBELXbUu1O+iSX+1FMXTwa9epwPYmi7EnCP+o@mail.gmail.com>
	<AANLkTikZ=TPN4_GXnUasRq-m8uwy6Spdzd=m_fR08Okt@mail.gmail.com>
	<AANLkTimvf8t5Rti73kYKV9cG3d7d7Y=OCn57LQNzUuTR@mail.gmail.com>
Date: Sun, 21 Nov 2010 09:06:35 +0800
Message-ID: <AANLkTin_-05__F-CMPcOFHceJraJgDN3EGaHe4MT-EyM@mail.gmail.com>
Subject: Re: [PATCH 0/2] Generic hardware error reporting support
From: huang ying <huang.ying.caritas@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 8:50 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, Nov 20, 2010 at 4:42 PM, huang ying
> <huang.ying.caritas@gmail.com> wrote:
>>
>> I don't want to hide the information from the MIS people with the
>> tool. I want to show the information to MIS people in a better way.
>
> You really don't understand, do you?

I mean the tool can cook the raw error information from kernel and
report it in a better way. Yes. You are right that the user space
error daemon is not popular now. But every tool has its beginning,
isn't it? I know it is impossible for this tool becomes popular in
desktop users because hardware error is really rare for them. But it
may become popular for server farm administrators, to them hardware
errors are common and they really care about the RAS.

> People won't even _know_ about your tool.  It's too f*cking
> specialized. They'll have come from other Unixes, they'll have come
> from older Linux versions, they don't know, they don't care.
>
> They _do_ know about system logs.

I have no objection to report hardware errors in system logs too. So
these people can get the information too. I just want to add another
tool oriented interface too. So that some other users (like cluster
administrator) can get their work done better too.

> The most common kind of "system admin" is the random end-user. Now,
> admittedly Intel seems to have its head up its arse on the whole
> "regular people care about ECC and random memory corruption", and it
> may be that consumer chips simply won't support the whole magic error
> handling code, but the point remains: we don't want yet another
> obscure error reporting tool that almost nobody knows about.
> Especially for errors that are so rare that you'll never notice if you
> are missing them.

For desktop users, that is true. But for cluster administrator, the
hardware errors are really common. Some engineer of local search
engine vendor told me that they have broken DIMM everyday.

Best Regards,
Huang Ying
