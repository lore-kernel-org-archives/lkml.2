Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447Ab1JNVys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 17:54:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49365 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044Ab1JNVyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 17:54:47 -0400
Message-ID: <4E98AF71.40303@zytor.com>
Date: Fri, 14 Oct 2011 14:53:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH RFC V4 09/10] x86/jump_label: use GENERIC_NOP5_ATOMIC
 instead of jmp5 +0
References: <cover.1318464169.git.jeremy.fitzhardinge@citrix.com>  <34ede5db1571d541a5c3fc49923bb353a37dd431.1318464413.git.jeremy.fitzhardinge@citrix.com>  <4E97067A.2070305@zytor.com> <4E97188A.6040400@goop.org> <1318531022.12224.13.camel@gandalf.stny.rr.com>
In-Reply-To: <1318531022.12224.13.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 11:37 AM, Steven Rostedt wrote:
> On Thu, 2011-10-13 at 09:57 -0700, Jeremy Fitzhardinge wrote:
>> On 10/13/2011 08:40 AM, H. Peter Anvin wrote:
>>> On 10/12/2011 05:08 PM, Jeremy Fitzhardinge wrote:
>>>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>>>
>>>> GENERIC_NOP5_ATOMIC should make a better nop.
>>>>
>>> On 32 bits, yes.  On 64 bits you should use P6_NOP5_ATOMIC.
>>
>> Something like this?
>>
> 
> No, we only care about 5byte nops here. Look at ideal_nop in
> alterative.c
> 

He needs a compile-time alternative.

	-hpa

