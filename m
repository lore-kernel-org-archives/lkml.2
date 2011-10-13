Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab1JMSLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 14:11:54 -0400
Received: from claw.goop.org ([74.207.240.146]:49880 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929Ab1JMSLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 14:11:53 -0400
Message-ID: <4E9716B8.8050406@goop.org>
Date: Thu, 13 Oct 2011 09:50:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
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
References: <cover.1318464169.git.jeremy.fitzhardinge@citrix.com> <34ede5db1571d541a5c3fc49923bb353a37dd431.1318464413.git.jeremy.fitzhardinge@citrix.com> <4E97067A.2070305@zytor.com>
In-Reply-To: <4E97067A.2070305@zytor.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 08:40 AM, H. Peter Anvin wrote:
> On 10/12/2011 05:08 PM, Jeremy Fitzhardinge wrote:
>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> GENERIC_NOP5_ATOMIC should make a better nop.
>>
> On 32 bits, yes.  On 64 bits you should use P6_NOP5_ATOMIC.

So the cleanest way of fixing that is to make the GENERIC_NOP*  be
defined to P6_NOP* on 64-bit then?  Assuming I'm correct in guessing
that the intent of GENERIC_NOP* is "a basically good-enough NOP that
will work on any x86".

    J
