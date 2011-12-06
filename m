Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab1LFTWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:22:42 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50803 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab1LFTWl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:22:41 -0500
MIME-Version: 1.0
In-Reply-To: <1323199215.32012.87.camel@twins>
References: <1318595833-29984-1-git-send-email-eranian@google.com>
	<1323124766.32012.49.camel@twins>
	<20111206094927.GA25782@mudshark.cambridge.arm.com>
	<1323169412.32012.69.camel@twins>
	<CABPqkBQq=ra+-O==qT+8DtFZ5T7=M4yJrnPJ_bb+UmUTGGQepQ@mail.gmail.com>
	<1323199215.32012.87.camel@twins>
Date: Tue, 6 Dec 2011 11:22:28 -0800
Message-ID: <CABPqkBQG9QF7Kx3uMZCBjin60+stNU88hy6Z1KzBn9W7j=uLCw@mail.gmail.com>
Subject: Re: [PATCH 00/12] perf_events: add support for sampling taken
 branches (v2)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "acme@redhat.com" <acme@redhat.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        "ravitillo@lbl.gov" <ravitillo@lbl.gov>,
        "paulus@samba.org" <paulus@samba.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 11:20 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2011-12-06 at 11:14 -0800, Stephane Eranian wrote:
>
>> >> > Other than the few comments given it all looks good. My main worry is
>> >> > the Intel only aspect, I'd really love for there to be another platform
>> >> > that could implement at least part of this.
>
>> There is a hardware branch buffer on all Itanium processors.
>> You can find the description for the McKinley implementation
>>  (Itanium2) branch buffer in section 10.3.9 from:
>> http://download.intel.com/design/Itanium2/manuals/25111003.pdf
>
>
> Yeah, I knew Itanic has it, but one its sinking (and doesn't have perf
> support), and two its still Intel ;-)
>
It's just an example of a different implementation of a branch buffer.
That's why I mentioned it. The question is: could the branch_stack
abstraction map to it. I think it could.

>
