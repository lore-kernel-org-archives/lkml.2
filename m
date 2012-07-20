Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab2GTWaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 18:30:11 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:17197 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab2GTWaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 18:30:09 -0400
Message-ID: <5009DBEC.5050505@hp.com>
Date: Fri, 20 Jul 2012 16:30:04 -0600
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
References: <20120720220841.GA32642@hp.com> <5009D770.1050905@zytor.com>
In-Reply-To: <5009D770.1050905@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 04:10 PM, H. Peter Anvin wrote:
> On 07/20/2012 03:08 PM, Khalid Aziz wrote:
>> Replace very long constants for EFI variable attributes
>> with shorter and more convenient names. Also create an
>> alias for the current longer names so as to not break
>> compatibility with current API since these constants
>> are used by userspace programs. This patch depends on
>> patch <https://lkml.org/lkml/2012/7/13/313>.
>
> I think these some from the EFI specifcation, so NAK IMO.
>
>     -hpa
>
This patch is based upon earlier discussion at 
<https://lkml.org/lkml/2012/7/13/320>.

You are right that EFI specification uses exactly these long names for 
the constants, but does that mean kernel must also use the exact same 
long constant names? I can see doing that for the sake of consistency. 
At the same time, can we make the kernel code more readable and retain 
compatibility with existing API by using aliases? I slightly prefer 
making kernel code more readable, but I could go either way.

-- 

Khalid Aziz
khalid.aziz@hp.com

