Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab0KUAvH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 19:51:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755119Ab0KUAvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 19:51:05 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTikZ=TPN4_GXnUasRq-m8uwy6Spdzd=m_fR08Okt@mail.gmail.com>
References: <1290154233-28695-1-git-send-email-ying.huang@intel.com>
 <AANLkTin_SyFFP_2=pKoS+8+4V1qXVWyrus7BKz8ENVsJ@mail.gmail.com>
 <AANLkTincYS7G1yb2ukT67qvpjwQmptXzQZabLQLYrEqn@mail.gmail.com>
 <AANLkTi=U7F7MS48dC=GgGqh=cm8YrtVhrm6sDXOma6Fc@mail.gmail.com>
 <AANLkTiki3d3Ft3-XJwFg8DUzUYcz3xPoYTzLZokLf+dv@mail.gmail.com>
 <AANLkTinAZgHbexU+LTUZHs-+7C0N990=kyuO-USV1Ncp@mail.gmail.com>
 <AANLkTinBBELXbUu1O+iSX+1FMXTwa9epwPYmi7EnCP+o@mail.gmail.com> <AANLkTikZ=TPN4_GXnUasRq-m8uwy6Spdzd=m_fR08Okt@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 20 Nov 2010 16:50:41 -0800
Message-ID: <AANLkTimvf8t5Rti73kYKV9cG3d7d7Y=OCn57LQNzUuTR@mail.gmail.com>
Subject: Re: [PATCH 0/2] Generic hardware error reporting support
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 4:42 PM, huang ying
<huang.ying.caritas@gmail.com> wrote:
>
> I don't want to hide the information from the MIS people with the
> tool. I want to show the information to MIS people in a better way.

You really don't understand, do you?

People won't even _know_ about your tool.  It's too f*cking
specialized. They'll have come from other Unixes, they'll have come
from older Linux versions, they don't know, they don't care.

They _do_ know about system logs.

The most common kind of "system admin" is the random end-user. Now,
admittedly Intel seems to have its head up its arse on the whole
"regular people care about ECC and random memory corruption", and it
may be that consumer chips simply won't support the whole magic error
handling code, but the point remains: we don't want yet another
obscure error reporting tool that almost nobody knows about.
Especially for errors that are so rare that you'll never notice if you
are missing them.

                   Linus
