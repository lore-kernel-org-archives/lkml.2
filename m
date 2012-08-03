Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab2HCWIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 18:08:05 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:32885 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753110Ab2HCWIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 18:08:00 -0400
MIME-Version: 1.0
In-Reply-To: <20120803215954.GA4489@kroah.com>
References: <1344013004-32211-1-git-send-email-vikram.pandita@ti.com>
 <m2628z6euk.fsf@firstfloor.org> <CAFm5wm3ScpUU5wa=ei3TY0zjU4kVbOgJMmE5_QDpwy7B-TJa+A@mail.gmail.com>
 <20120803200822.GC731@harshnoise.musicnaut.iki.fi> <CAFm5wm2sf9LnZNj9_BDYTF9G7XH32fOL3x5n=kZ-1ih0Cek2DQ@mail.gmail.com>
 <20120803215954.GA4489@kroah.com>
From: "Pandita, Vikram" <vikram.pandita@ti.com>
Date: Fri, 3 Aug 2012 15:07:39 -0700
Message-ID: <CAFm5wm1_-JP0xjDdBvAcqqpZPQvxJPsmNtUOFQyaNw=6H_JJcg@mail.gmail.com>
Subject: Re: [PATCH v3] printk: add option to print cpu id
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, Andi Kleen <andi@firstfloor.org>,
        kay@vrfy.org, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 3, 2012 at 2:59 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Aug 03, 2012 at 02:24:20PM -0700, Pandita, Vikram wrote:
>> Aaro
>>
>> On Fri, Aug 3, 2012 at 1:08 PM, Aaro Koskinen <aaro.koskinen@iki.fi> wrote:
>> > Hi,
>> >
>> > On Fri, Aug 03, 2012 at 11:25:37AM -0700, Pandita, Vikram wrote:
>> >> > And really: Wasting 1/3 of the 80 character line is too much.
>> >>
>> >> You _WASTE_ 4 chars only if you are interested in this info by
>> >> enabling: CONFIG_PRINTK_CPUID
>> >
>> > I guess you waste 4 + 3 chars? You could optimize the length by checking
>> > CONFIG_NR_CPUS?
>>
>> Good point.
>> Looks there is a variable 'nr_cpu_ids' that could be used as well.
>>
>> If there is general consensus that the patch can help the arm
>> community, and others in general,
>> this optimization should be easy to implement - saving few chars space
>> in each line of console output.
>>
>> For now i will stick to this v3 version of path, unless you think otherwise.
>
> I don't think is is something that anyone needs, and if you do, as
> pointed out, you can use the trace function to make it happen.
>

This was something that got used internally and helped at times.
This attempt to give back to community, but i understand the rationale to go
with larger consensus.

At least the patch is out there in public for anyone to make use of.

> Adding features are not "free", someone has to maintain them and all of
> the other work involved with it.  So don't just think that because it is
> hidden behind a config option, that it doesn't affect people.

At least the v3 patch is a complete working implementation wrt
kernel/printk.c file
as it exists on linus tree master today.

Understand long term this does have maintenance overhead just like
printk_time does.

>
> greg k-h
