Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab0KYE1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 23:27:20 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:45965 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab0KYE1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 23:27:18 -0500
Date: Wed, 24 Nov 2010 23:27:01 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Mark Lord <kernel@teksavvy.com>
Cc: Huang Ying <ying.huang@intel.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/2] Generic hardware error reporting support
In-reply-to: <4CEDCCF5.5030308@teksavvy.com>
Message-id: <alpine.LFD.2.00.1011242320000.637@x980>
References: <1290154233-28695-1-git-send-email-ying.huang@intel.com>
 <AANLkTin_SyFFP_2=pKoS+8+4V1qXVWyrus7BKz8ENVsJ@mail.gmail.com>
 <AANLkTincYS7G1yb2ukT67qvpjwQmptXzQZabLQLYrEqn@mail.gmail.com>
 <AANLkTi=U7F7MS48dC=GgGqh=cm8YrtVhrm6sDXOma6Fc@mail.gmail.com>
 <AANLkTiki3d3Ft3-XJwFg8DUzUYcz3xPoYTzLZokLf+dv@mail.gmail.com>
 <AANLkTinAZgHbexU+LTUZHs-+7C0N990=kyuO-USV1Ncp@mail.gmail.com>
 <AANLkTinBBELXbUu1O+iSX+1FMXTwa9epwPYmi7EnCP+o@mail.gmail.com>
 <AANLkTikZ=TPN4_GXnUasRq-m8uwy6Spdzd=m_fR08Okt@mail.gmail.com>
 <AANLkTimvf8t5Rti73kYKV9cG3d7d7Y=OCn57LQNzUuTR@mail.gmail.com>
 <AANLkTin_-05__F-CMPcOFHceJraJgDN3EGaHe4MT-EyM@mail.gmail.com>
 <4CEB0037.3000303@teksavvy.com> <1290472198.2903.156.camel@yhuang-dev>
 <4CEDCCF5.5030308@teksavvy.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ... most *NIX tools store and manage data in _text_ form.

If the hardware error dump is complicated there is a trade-off
between making things human readable and putting a lot of
comlicated parsing code into the kernel.  Maybe the kernel
should just dump hex "text" in some cases and let a user-program
parse the syslog?

What do do if the hardware error log is very large?
Is there a limit on how much is practical to send through syslog?

thanks,
-Len Brown, Intel Open Source Technology Center
