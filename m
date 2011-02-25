Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab1BYI4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 03:56:11 -0500
Received: from smtp-out.google.com ([74.125.121.67]:14977 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab1BYI4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 03:56:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Mcv9Jz/hNwrVKxw/daGhPRpQZ4HlBPu1kHXzRgjWh41GRaps+cxqLCJdpw23fz+f28
         l6m+iMm7tpQna3C1hvVw==
MIME-Version: 1.0
In-Reply-To: <1298624119.2835.87.camel@minggr.sh.intel.com>
References: <1298555968.2220.15.camel@localhost>
	<1298556237.2220.19.camel@localhost>
	<20110224165705.GA15498@elte.hu>
	<1298624119.2835.87.camel@minggr.sh.intel.com>
Date: Fri, 25 Feb 2011 09:56:05 +0100
Message-ID: <AANLkTimP8h_rvJ6ejMy9Ys-3e8M3cbNGY6c3yRCgrGL+@mail.gmail.com>
Subject: Re: [PATCH -tip] perf: x86, add SandyBridge support
From: Stephane Eranian <eranian@google.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lin,

I have a patch almost ready that updates the PEBS constraints for all CPUs.
I'll add the SNB constraints as well.

On Fri, Feb 25, 2011 at 9:55 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> On Fri, 2011-02-25 at 00:57 +0800, Ingo Molnar wrote:
>> * Lin Ming <ming.m.lin@intel.com> wrote:
>>
>> > Adds SandyBridge support to perf.
>>
>> Wondering, have you tested things like PEBS? You can do it via:
>>
>>       perf record -e instructions:p -a sleep 10
>>       perf top -e instructions:p
>>
>> ('p' stands for 'precise')
>
> Let me do more PEBS tests...
>
>>
>> Also, please list known limitations in the changelog.
>
> OK.
>
>>
>> Thanks,
>>
>>       Ingo
>
>
>
