Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab2GTWfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 18:35:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52955 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466Ab2GTWfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 18:35:12 -0400
Message-ID: <5009DD10.7010205@zytor.com>
Date: Fri, 20 Jul 2012 15:34:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Khalid Aziz <khalid.aziz@hp.com>
CC: mjg@redhat.com, mikew@google.com, tony.luck@intel.com,
        keescook@chromium.org, gong.chen@linux.intel.com,
        gregkh@linuxfoundation.org, paul.gortmaker@windriver.com,
        maxin.john@gmail.com, rdunlap@xenotime.net, matt.fleming@intel.com,
        olof@lixom.net, dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Shorten constant names for EFI variable attributes
References: <20120720220841.GA32642@hp.com> <5009D770.1050905@zytor.com> <5009DBEC.5050505@hp.com>
In-Reply-To: <5009DBEC.5050505@hp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 03:30 PM, Khalid Aziz wrote:
> On 07/20/2012 04:10 PM, H. Peter Anvin wrote:
>> On 07/20/2012 03:08 PM, Khalid Aziz wrote:
>>> Replace very long constants for EFI variable attributes
>>> with shorter and more convenient names. Also create an
>>> alias for the current longer names so as to not break
>>> compatibility with current API since these constants
>>> are used by userspace programs. This patch depends on
>>> patch <https://lkml.org/lkml/2012/7/13/313>.
>>
>> I think these some from the EFI specifcation, so NAK IMO.
>>
>>     -hpa
>>
> This patch is based upon earlier discussion at
> <https://lkml.org/lkml/2012/7/13/320>.
>
> You are right that EFI specification uses exactly these long names for
> the constants, but does that mean kernel must also use the exact same
> long constant names? I can see doing that for the sake of consistency.
> At the same time, can we make the kernel code more readable and retain
> compatibility with existing API by using aliases? I slightly prefer
> making kernel code more readable, but I could go either way.
>

I think it makes the kernel code less readable, because now you not only 
need to understand the kernel code and the EFI spec, but also how the 
two maps onto each other. The fact that you then have to introduce 
aliases indicates to me that you're doing something actively broken.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.



