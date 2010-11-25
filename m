Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab0KYCmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 21:42:04 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:26235 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754039Ab0KYCmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 21:42:02 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAIpb7UxLd/sX/2dsb2JhbAAHg0jNA5BogSGDM3MEhFs
X-IronPort-AV: E=Sophos;i="4.59,251,1288584000"; 
   d="scan'208";a="83532255"
Message-ID: <4CEDCCF5.5030308@teksavvy.com>
Date: Wed, 24 Nov 2010 21:41:57 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: huang ying <huang.ying.caritas@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/2] Generic hardware error reporting support
References: <1290154233-28695-1-git-send-email-ying.huang@intel.com>	 <AANLkTin_SyFFP_2=pKoS+8+4V1qXVWyrus7BKz8ENVsJ@mail.gmail.com>	 <AANLkTincYS7G1yb2ukT67qvpjwQmptXzQZabLQLYrEqn@mail.gmail.com>	 <AANLkTi=U7F7MS48dC=GgGqh=cm8YrtVhrm6sDXOma6Fc@mail.gmail.com>	 <AANLkTiki3d3Ft3-XJwFg8DUzUYcz3xPoYTzLZokLf+dv@mail.gmail.com>	 <AANLkTinAZgHbexU+LTUZHs-+7C0N990=kyuO-USV1Ncp@mail.gmail.com>	 <AANLkTinBBELXbUu1O+iSX+1FMXTwa9epwPYmi7EnCP+o@mail.gmail.com>	 <AANLkTikZ=TPN4_GXnUasRq-m8uwy6Spdzd=m_fR08Okt@mail.gmail.com>	 <AANLkTimvf8t5Rti73kYKV9cG3d7d7Y=OCn57LQNzUuTR@mail.gmail.com>	 <AANLkTin_-05__F-CMPcOFHceJraJgDN3EGaHe4MT-EyM@mail.gmail.com>	 <4CEB0037.3000303@teksavvy.com> <1290472198.2903.156.camel@yhuang-dev>
In-Reply-To: <1290472198.2903.156.camel@yhuang-dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-11-22 07:29 PM, Huang Ying wrote:
> On Tue, 2010-11-23 at 07:43 +0800, Mark Lord wrote:
>> On 10-11-20 08:06 PM, huang ying wrote:
>>>
>>> I have no objection to report hardware errors in system logs too. So
>>> these people can get the information too. I just want to add another
>>> tool oriented interface too. So that some other users (like cluster
>>> administrator) can get their work done better too.
>>
>> So, use the standard interface for the tool:  syslog.
>
> Although it may be possible to extract some information from syslog and
> parse it in a fault tolerant way, we can only use that human oriented
> interface for a tool? That sounds like hack.

No, that sounds like the *NIX programming philosophy.

You may have already noticed that most *NIX tools store
and manage data in _text_ form.  That makes it easy to
understand, easy to parse/process, and generally better
in almost every respect.

Other platforms (GNOME, MS-Windows) prefer a binary format
that requires special tools to view/access.  Ugh.

Cheers
