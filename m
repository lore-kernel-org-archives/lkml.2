Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759159Ab0JYRUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 13:20:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755326Ab0JYRUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 13:20:06 -0400
Message-ID: <4CC5BC0E.7090601@redhat.com>
Date: Mon, 25 Oct 2010 15:19:10 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Tony Luck <tony.luck@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Borislav Petkov <petkovbb@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Don Zickus <dzickus@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>, Borislav Petkov <bp@amd64.org>
Subject: Re: [NAK] Re: [PATCH -v2 9/9] ACPI, APEI, Generic Hardware Error
 Source POLL/IRQ/NMI notification type support
References: <1287992610-14996-1-git-send-email-ying.huang@intel.com>	<1287992610-14996-10-git-send-email-ying.huang@intel.com>	<20101025084553.GA27119@elte.hu>	<1287997112.2862.322.camel@yhuang-dev>	<20101025091913.GA17622@basil.fritz.box>	<20101025111530.GA27659@elte.hu>	<4CC5726B.1020207@redhat.com> <AANLkTin=WM5AN_z_SxaKgOta-Q0xQnyO2S-G5w7JOQSh@mail.gmail.com>
In-Reply-To: <AANLkTin=WM5AN_z_SxaKgOta-Q0xQnyO2S-G5w7JOQSh@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 25-10-2010 15:07, Tony Luck escreveu:
> On Mon, Oct 25, 2010 at 5:04 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> We had some discussions with Intel during the Collaboration summit about that, trying to
>> integrate Nehalem EX on such environment, with, unfortunately, didn't happen, as Intel
>> didn't release any (public) datasheet describing Nehalem EX memory controller, nor wrote
>> such driver.
> 
> The chipset registers that are needed to write an EDAC driver for
> Nehalem-EX (a.k.a Xeon
> 7500 series) are not accessible to OS (ring 0) code. Documenting them
> wouldn't change this.

Yeah, I know.

The error reporting mechanism could do something similar to i7core_edac
driver to parse the MCE NMI errors to userspace via EDAC interface, but
without any way to get the memory topology, this wouldn't work. With some 
documentation, maybe we could find a way for a kernel code to retrieve 
the memory topology, maybe via BIOS, and make it work.


>> As most of us will be in Boston next week, I've reserved a BoF at Plumbers for us to discuss
>> about this subject:
>>
>> http://www.linuxplumbersconf.org/2010/ocw/proposals/921
> 
> An excellent idea. See you there.

OK,

See you there.

Thanks,
Mauro
