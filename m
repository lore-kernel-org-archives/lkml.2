Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab0GLSPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 14:15:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61654 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185Ab0GLSPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 14:15:31 -0400
Message-ID: <4C3B5AC9.3070604@oracle.com>
Date: Mon, 12 Jul 2010 11:11:21 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Setup early console as early as possible
References: <4C3A3B27.7020009@oracle.com> <4C3AD94C.7070807@cs.helsinki.fi> <4C3B38F7.1050400@zytor.com> <20100712174420.GC5687@lenovo> <4C3B5A4A.4070107@zytor.com>
In-Reply-To: <4C3B5A4A.4070107@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C3B5B6D.0237:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2010 11:09 AM, H. Peter Anvin wrote:
> On 07/12/2010 10:44 AM, Cyrill Gorcunov wrote:
>>
>> Peter, while reviewing this patch I found another nit in
>> context of early_param usage, so the patch is below. It's
>> completely trivial. Actually I thought I've already fixed
>> all early_param cases long ago but this one somehow sneaked ;)
>>
>> Anyway, Yinghai, Peter,
>>
>> I'm not sure but can't we use some boot_param "pad" field for
>> "being copied" flag instead of new variable? There is a case
>> when boot_param is used as __initdata and I'm not sure we clear
>> this section explicitly.
>>
> 
> Actually, even better would be to simply use boot_params.hdr.version,
> which will never be zero.

Jeremy,

any reason that xen cat not use x86_64_start_kernel directly?

Thanks

Yinghai
