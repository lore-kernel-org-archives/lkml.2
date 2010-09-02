Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab0IBQGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 12:06:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab0IBQGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 12:06:07 -0400
Message-ID: <4C7FCB6C.9020304@redhat.com>
Date: Thu, 02 Sep 2010 19:06:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: kernelshark plugins and ftrace array fields
References: <4C7F9639.7000804@redhat.com>	 <1283437521.2356.136.camel@gandalf.stny.rr.com> <4C7FB603.60609@redhat.com> <1283442737.2356.212.camel@gandalf.stny.rr.com>
In-Reply-To: <1283442737.2356.212.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/02/2010 06:52 PM, Steven Rostedt wrote:
>
>> plugin_kvm.c:
>>
>> kvm_emulate_insn_handler()
>> {
>>      fetch insn array and len field
>>      feed into disassembler
>>      trace_seq_printf() the disassembled instruction
>> }
> I don't have that tracepoint in any of my kernels. Is this new? I guess
> if I see the TRACE_EVENT() I could emulate something and work with it.
>

e46479f852ada, in 2.6.35-rc1.

-- 
error compiling committee.c: too many arguments to function

