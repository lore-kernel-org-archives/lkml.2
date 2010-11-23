Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab0KWAaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 19:30:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:14950 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab0KWAaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 19:30:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,239,1288594800"; 
   d="scan'208";a="629355137"
Subject: Re: [PATCH 0/2] Generic hardware error reporting support
From: Huang Ying <ying.huang@intel.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: huang ying <huang.ying.caritas@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4CEB0037.3000303@teksavvy.com>
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
	 <4CEB0037.3000303@teksavvy.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 08:29:58 +0800
Message-ID: <1290472198.2903.156.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 07:43 +0800, Mark Lord wrote:
> On 10-11-20 08:06 PM, huang ying wrote:
> >
> > I have no objection to report hardware errors in system logs too. So
> > these people can get the information too. I just want to add another
> > tool oriented interface too. So that some other users (like cluster
> > administrator) can get their work done better too.
> 
> So, use the standard interface for the tool:  syslog.

Although it may be possible to extract some information from syslog and
parse it in a fault tolerant way, we can only use that human oriented
interface for a tool? That sounds like hack.

> Have this obscure new tool simply parse the log messages,
> and the send/save the data whatever way you like.
> 
> No new specialized kernel API required.

Adding a new device file will be seen as a new kernel API?

Best Regards,
Huang Ying


