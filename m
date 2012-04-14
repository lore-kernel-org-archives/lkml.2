Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab2DNLkn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 07:40:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44593 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab2DNLkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 07:40:42 -0400
MIME-Version: 1.0
In-Reply-To: <1334395065.2528.43.camel@twins>
References: <CA+1xoqcf6qJOouKXGEHsjWSBJdA7qtMnuVopq+hoHS+TX8fvSg@mail.gmail.com>
 <CA+1xoqcJAwgTgQG=nZPsH_SLkPFkGt2rUiVWGn5SO5JOAC1RAA@mail.gmail.com>
 <4F75BED4.9050005@linux.vnet.ibm.com> <1333118719.2960.27.camel@laptop>
 <4F76B7B9.5080709@linux.vnet.ibm.com> <1334395065.2528.43.camel@twins>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Sat, 14 Apr 2012 13:40:22 +0200
Message-ID: <CA+1xoqe6UL36=F2mg8cYJsyW9_kxjmdX-H=khdKmbhg+mEpbmw@mail.gmail.com>
Subject: Re: sched: WARNING: at include/linux/cpumask.h:108 select_fallback_rq+0x241/0x280()
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, mingo@kernel.org,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>, vapier@gentoo.org,
        rusty@rustcorp.com.au
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 11:17 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sat, 2012-03-31 at 13:22 +0530, Srivatsa S. Bhat wrote:
>>
>> One of the perils of using macros instead of true function calls :-(
>>
> You can do type checking in macros too, its not pretty, but there's
> several such things already, see min()/max() for example.

Would it make sense to somehow standardize type checking in kernel
macros? Possibly a set of wrappers that would make type checking easy
to get into new and existing macros?
