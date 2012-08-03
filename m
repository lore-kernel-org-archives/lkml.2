Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab2HCVYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 17:24:45 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:35340 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753133Ab2HCVYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 17:24:41 -0400
MIME-Version: 1.0
In-Reply-To: <20120803200822.GC731@harshnoise.musicnaut.iki.fi>
References: <1344013004-32211-1-git-send-email-vikram.pandita@ti.com>
 <m2628z6euk.fsf@firstfloor.org> <CAFm5wm3ScpUU5wa=ei3TY0zjU4kVbOgJMmE5_QDpwy7B-TJa+A@mail.gmail.com>
 <20120803200822.GC731@harshnoise.musicnaut.iki.fi>
From: "Pandita, Vikram" <vikram.pandita@ti.com>
Date: Fri, 3 Aug 2012 14:24:20 -0700
Message-ID: <CAFm5wm2sf9LnZNj9_BDYTF9G7XH32fOL3x5n=kZ-1ih0Cek2DQ@mail.gmail.com>
Subject: Re: [PATCH v3] printk: add option to print cpu id
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Andi Kleen <andi@firstfloor.org>, gregkh@linuxfoundation.org, kay@vrfy.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aaro

On Fri, Aug 3, 2012 at 1:08 PM, Aaro Koskinen <aaro.koskinen@iki.fi> wrote:
> Hi,
>
> On Fri, Aug 03, 2012 at 11:25:37AM -0700, Pandita, Vikram wrote:
>> > And really: Wasting 1/3 of the 80 character line is too much.
>>
>> You _WASTE_ 4 chars only if you are interested in this info by
>> enabling: CONFIG_PRINTK_CPUID
>
> I guess you waste 4 + 3 chars? You could optimize the length by checking
> CONFIG_NR_CPUS?

Good point.
Looks there is a variable 'nr_cpu_ids' that could be used as well.

If there is general consensus that the patch can help the arm
community, and others in general,
this optimization should be easy to implement - saving few chars space
in each line of console output.

For now i will stick to this v3 version of path, unless you think otherwise.

>
> A.
