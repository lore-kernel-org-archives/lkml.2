Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab0JTGFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:05:22 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:57890 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757146Ab0JTGFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:05:22 -0400
Message-ID: <4CBE8669.5080002@euromail.se>
Date: Wed, 20 Oct 2010 08:04:25 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100922 Thunderbird/3.1.4
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>,
        Hans de Goede <j.w.r.degoede@hhs.nl>,
        Alistair John Strachan <alistair@devzero.co.uk>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Luca Tettamanti <kronos.it@gmail.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Juerg Haefliger <juergh@gmail.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Jim Cromie <jim.cromie@gmail.com>,
        Roger Lucas <vt8231@hiddenengine.co.uk>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/hwmon: Use pr_fmt and pr_<level>
References: <1287530020.10409.594.camel@Joe-Laptop>	 <20101020032938.GA20095@ericsson.com>	 <1287545658.10409.606.camel@Joe-Laptop>	 <20101020035346.GA20178@ericsson.com> <1287547662.10409.618.camel@Joe-Laptop>
In-Reply-To: <1287547662.10409.618.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1P8Rmq-0001ZH-6H.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1P8Rmq-0001ZH-6H 87debaccac5d5a111927e2bc0cdba217
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2010 06:07 AM, Joe Perches wrote:

> On Tue, 2010-10-19 at 20:53 -0700, Guenter Roeck wrote:
>> On Tue, Oct 19, 2010 at 11:34:18PM -0400, Joe Perches wrote:
>>> On Tue, 2010-10-19 at 20:29 -0700, Guenter Roeck wrote:
>>>> There are several lines longer than 80 characters.
>>>> Does this rule no longer apply ?
>>> 80 columns isn't checked for printk format strings.
>> Interesting.
>>> A kernel general preference may be to keep formats as
>>> a single string without line breaks so that grep works
>>> better.
>>>> Oddly enough, there are only four checkpatch warnings about long lines,
>>>> even though there are many more.
>>> The version I use doesn't show any warnings.
>> checkpatch.pl from both v2.6.36-rc7 and v2.6.36-rc6 do report warnings.
>> Looks like those versions flag long lines for pr_warn. Is your version
>> older or newer ?
> 
> Newer.  It adds pr_warn to the exempted list, not just pr_warning.
> 
>> Anyway, would it be possible to split the patch into one patch per file ?
> 
> Oh sure.  It's trivial to do that.
> 
>> I don't know how Jean thinks about it, but in my opinion it would be cleaner,
>> permit revert on a single patch/file instead of having to revert the entire series,
>> it would simplify review, and it would make it much easier to cherry-pick 
>> pieces into other releases if needed.
> 
> Jean, do you have a preference?
> I'll resubmit if you want it separated.


Yes please, that would be nice.

Thanks,
Henrik
