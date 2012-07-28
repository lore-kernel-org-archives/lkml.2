Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab2G1Btq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 21:49:46 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:47655 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab2G1Btp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 21:49:45 -0400
Message-ID: <50134531.5060007@linaro.org>
Date: Fri, 27 Jul 2012 18:49:37 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: Colin Cross <ccross@google.com>, Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, arve@android.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 0/7] KDB: Kiosk (reduced capabilities) mode
References: <20120726142514.GA32158@lizard> <CAMbhsRSM3QwwVfUMBWq1bDJxHX+Ox2CQtbvJVmemuMWjxfmDoQ@mail.gmail.com> <20120728012632.GA1766@lizard>
In-Reply-To: <20120728012632.GA1766@lizard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072801-6148-0000-0000-00000816D9F2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2012 06:26 PM, Anton Vorontsov wrote:
> On Fri, Jul 27, 2012 at 12:30:49PM -0700, Colin Cross wrote:
>>> The are two use-cases for the mode, one is evil, but another is quite
>>> legitimate.
>>>
>>> The evil use case is used by some (ahem) phone manufaturers that want
>>> to have a debuging facilities on a production device, but still don't
>>> want you to use the debugger to gain root access. I don't like locked
>>> phones, and I would not touch this/get my hands dirty by implementing
>>> the feature just for this evil (IMHO) use case.
>> The point of the reduced feature set in FIQ debugger is not to prevent
>> you from accessing your own phone, it designed to prevent others from
>> trivially rooting your phone and reading your data.  Both locked and
>> unlocked phones run FIQ debugger.  Would you carry a phone with
>> personal data on it and KGDB enabled on the serial console?
> Short answer: yes, I would carry such a phone. :-)
>
> Long answer:
>
> If someone was so interested in cracking the phone/data and so
> ended up with attaching serial console and attempted to use debugger
> techniques to gain access to my data, then thief's next step would be
> soldering a few wires to JTAG spots, and it will be all done in
> minutes. Knowledge-wise, using JTAG is even more trivial than using the
> debugger techniques to get to my data, you just need some HW skills.

The serial console on some of these phones are accessed via the 
headphone jack.

Imagine an airline provides free noise cancelling headphones for 
flights. Those headphones are of course "smart" and covertly try to 
quickly capture data off of the phone's debugger interface, storing on 
some headphone internal flash, all without the user noticing.

So I think Colin's concerns (regardless of any paranoia about phone 
OEM's intentions) is reasonable.

thanks
-john

