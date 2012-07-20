Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab2GTWq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 18:46:29 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:30475 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2GTWq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 18:46:28 -0400
Message-ID: <5009DFBF.7060009@hp.com>
Date: Fri, 20 Jul 2012 16:46:23 -0600
From: Khalid Aziz <khalid.aziz@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: mjg@redhat.com, mikew@google.com, tony.luck@intel.com,
        keescook@chromium.org, gong.chen@linux.intel.com,
        gregkh@linuxfoundation.org, paul.gortmaker@windriver.com,
        maxin.john@gmail.com, rdunlap@xenotime.net, matt.fleming@intel.com,
        olof@lixom.net, dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Shorten constant names for EFI variable attributes
References: <20120720220841.GA32642@hp.com> <5009D770.1050905@zytor.com> <5009DBEC.5050505@hp.com> <5009DD10.7010205@zytor.com>
In-Reply-To: <5009DD10.7010205@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 04:34 PM, H. Peter Anvin wrote:
> On 07/20/2012 03:30 PM, Khalid Aziz wrote:
>>
>> This patch is based upon earlier discussion at
>> <https://lkml.org/lkml/2012/7/13/320>.
>>
>> You are right that EFI specification uses exactly these long names for
>> the constants, but does that mean kernel must also use the exact same
>> long constant names? I can see doing that for the sake of consistency.
>> At the same time, can we make the kernel code more readable and retain
>> compatibility with existing API by using aliases? I slightly prefer
>> making kernel code more readable, but I could go either way.
>>
>
> I think it makes the kernel code less readable, because now you not 
> only need to understand the kernel code and the EFI spec, but also how 
> the two maps onto each other. The fact that you then have to introduce 
> aliases indicates to me that you're doing something actively broken.
>
>     -hpa
>
As I think more about it, existence of aliases could also potentially 
create confusion where someone adding new code to kernel chooses to use 
the long name instead. Maybe unless we can make a clean break from long 
names, it is not worth doing this and that is going to be problematic 
because of the existing usage in userspace programs.

Matthew, do you have a different point of view?

-- 
Khalid
khalid.aziz@hp.com

