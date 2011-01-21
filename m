Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab1AUQcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 11:32:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42001 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab1AUQcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 11:32:19 -0500
X-User-Agent: K-9 Mail for Android
References: <20110106204513.669098445@linux.com> <20110106204525.222395863@linux.com> <4D263C91.30709@zytor.com> <alpine.DEB.2.00.1101070907060.3014@router.home> <20110107180419.GB23082@Krystal> <alpine.DEB.2.00.1101071227450.3014@router.home> <20110108172453.GF13269@mtj.dyndns.org> <4D393636.4040607@cs.helsinki.fi> <20110121092649.GA2832@htj.dyndns.org> <4D39A6EB.70705@zytor.com> <20110121154831.GE2832@htj.dyndns.org>
In-Reply-To: <20110121154831.GE2832@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for this_cpu_cmpxchg_double
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 21 Jan 2011 08:30:41 -0800
To: Tejun Heo <tj@kernel.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Christoph Lameter <cl@linux.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c661a1e2-4e08-4e6b-b2c8-93e231be981f@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a technical argument: any noninline version will have actual code overhead.

"Tejun Heo" <tj@kernel.org> wrote:

>Hello, Peter.
>
>On Fri, Jan 21, 2011 at 07:31:55AM -0800, H. Peter Anvin wrote:
>> I really object to passing two pointers where one of them has to be a
>> fixed offset to the other.  That really doesn't make any sense.
>
>Yeah, I hear you, but it really comes down to which ugliness disgusts
>one the most.  That, unfortunately, is inherently very subjective when
>there's no significantly better choice.
>
>For me, the double parameter thing at least seems to have the
>advantages of being able to verify the two intended memory locations
>to be used actually are together and looking ugly reflecting its true
>nature.
>
>The inherent ugliness stems from the fact that we don't have the
>built-in data type to properly deal with this.  Array of length two
>might be better fit, but I can see as many downsides with that too.
>
>So, if anyone can give something clearly better for technical reasons,
>I'll be more than happy to take it, but as it currently stands, it
>seems we'll have to choose one among uglies and not everyone would be
>happy about the choice.  :-(
>
>Thanks.
>
>-- 
>tejun

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
