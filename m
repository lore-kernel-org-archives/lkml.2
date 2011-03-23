Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab1CWTsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 15:48:51 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59674 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576Ab1CWTsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 15:48:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nA8+XSH4aIPzIzU+f2Q4JjyLq7tntMQcbXDO3YH45RNyGD41vYCNY05IVPjdnsc0U1
         LkAos7VLzRHIbbpSIa3j6yglCTjoJ4fo2XsMsp6l0i/yDLl0L8cxIrsjji6YWQq5q2+7
         7l+R5oESh+2bLzOQZvc02be7XhP/WGsBnjOpI=
MIME-Version: 1.0
In-Reply-To: <20110323192338.GE22652@aftab>
References: <AANLkTim3gpBUtDQ=WnLRjzuwpNe=+m4wLK=maS1tLc8U@mail.gmail.com>
	<20110322133101.GB24006@gere.osrc.amd.com>
	<AANLkTimz0GR7HXgY5jxogfkNyJ2iVYWJGHRhsZtO4T+A@mail.gmail.com>
	<AANLkTikDqUptK8XdPpAGYKFskSL7ugfoh-VjNzyXU_3q@mail.gmail.com>
	<20110323192338.GE22652@aftab>
Date: Wed, 23 Mar 2011 20:48:48 +0100
Message-ID: <AANLkTiktv4+OeJW0yHBAeDtoHf4bvyx_W61AeZNozHzU@mail.gmail.com>
Subject: Re: Machine Check Exception and cpufreq
From: Giorgio <mywing81@gmail.com>
To: Borislav Petkov <bp@amd64.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@brodo.de" <linux@brodo.de>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "mchehab@redhat.com" <mchehab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/23 Borislav Petkov <bp@amd64.org>:
> On Wed, Mar 23, 2011 at 03:02:01PM -0400, Giorgio wrote:
>> 2011/3/22 Giorgio <mywing81@gmail.com>:
>> > 2011/3/22 Borislav Petkov <bp@amd64.org>:
>> >> this is very interesting. Question: is it possible to retest with
>> >> a newer kernel from upstream (say 2.6.38) to see whether the issue
>> >> persists? I'd like to rule out the possibility that powernow-k8 is
>> >> not causing any trouble which has been fixed in newer kernels in the
>> >> meantime.
>> >>
>> >> Thanks.
>> >
>> > Hello Borislav,
>> >
>> > thanks for your quick reply. Yes, I only tested it with the stock
>> > 2.6.32 kernel shipped with Ubuntu 10.04, but I will download the
>> > latest stable kernel from kernel.org (2.6.38) and test again. I'll
>> > come back to you in the following days. Regards,
>>
>> Borislav,
>>
>> I tested again with 2.6.38 kernel: the system was stressed for several
>> hours with various activities (compiling, copying data back and forth
>> from two hard drives, encoding/decoding video streams, etc) but I was
>> not able to reproduce the problem, so I guess it has been fixed.
>> If you're interested here's the info I collected with 2.6.38:
>>
>> http://mywing.altervista.org/tmp/info-2.6.38.log
>
> Great. It's either fixed or latest powernow-k8 changes timings so as not
> to trigger it anymore, because your issue looks like the chipset could
> by doing something fishy with CRC during Pstate transitions.
>
> If it happens again, try whether upgrading your BIOS solves it (although
> I'm pretty sceptical about getting newer BIOS for such an old board :-) ).

I am fairly sure I am using the latest BIOS available, and yes, I
admit this is quite an old board! :) Thank you again for looking at my
report.

Giorgio Vazzana
