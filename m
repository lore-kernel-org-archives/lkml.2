Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab2CFRPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 12:15:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44660 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab2CFRPk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 12:15:40 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of levinsasha928@gmail.com designates 10.50.191.163 as permitted sender) smtp.mail=levinsasha928@gmail.com; dkim=pass header.i=levinsasha928@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120306164835.GA26094@elliptictech.com>
References: <x49vcmhhj2f.fsf@segfault.boston.devel.redhat.com>
 <CA+1xoqe_xS95xKM2=X-Mq-_gc+DqzxF2D8YiuCf=0=7=mVKsyw@mail.gmail.com> <20120306164835.GA26094@elliptictech.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Tue, 6 Mar 2012 19:15:19 +0200
Message-ID: <CA+1xoqfzCb5X8wwvR1Bz+D6K20n7v3ChUR0E4Jqw_BWam5C7TQ@mail.gmail.com>
Subject: Re: the maxcpus= boot parameter broke somewhere along the line
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 6:48 PM, Nick Bowler <nbowler@elliptictech.com> wrote:
> On 2012-03-06 17:17 +0200, Sasha Levin wrote:
>> On Tue, Mar 6, 2012 at 4:59 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> > When booting my machine with maxcpus=1, it seems to be ignored with
>> > 3.3.0-rc3.  I know that 3.1.0-rc3 works fine, but I haven't had time to
>> > track it down any further than that.  I've attached the dmesg from my
>> > machine.  Let me know if there is any other information that would help
>> > in solving this.
>>
>> [snip]
>>
>> > Brought up 1 CPUs
>> > Total of 1 processors activated (4256.06 BogoMIPS).
>>
>> Looks like it indeed brings up only one CPU, what's the problem there?
>
> If you scroll further down it seems that the remaining CPUs are brought
> online near the end of the boot?
>
>  [...]
>  udev: starting version 147
>  SMP alternatives: switching to SMP code
>  WARNING! power/level is deprecated; use power/control instead
>  EDAC MC: Ver: 2.1.0
>  Booting Node 0 Processor 3 APIC 0x3
>  smpboot cpu 3: start_ip = 9a000
>  EDAC MC0: Giving out device to 'i3200_edac' 'i3200': DEV 0000:00:00.0
>  NMI watchdog enabled, takes one hw-pmu counter.
>  Booting Node 0 Processor 2 APIC 0x1
>  smpboot cpu 2: start_ip = 9a000
>  NMI watchdog enabled, takes one hw-pmu counter.
>  Booting Node 0 Processor 1 APIC 0x2
>  smpboot cpu 1: start_ip = 9a000
>  NMI watchdog enabled, takes one hw-pmu counter.

I can't reproduce it locally with a 3.3-rc5 kernel.
