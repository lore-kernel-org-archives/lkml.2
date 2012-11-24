Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750935Ab2KXFG2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 00:06:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35733 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab2KXFG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 00:06:26 -0500
Message-ID: <50B055C8.2030209@zytor.com>
Date: Fri, 23 Nov 2012 21:06:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Yuhong Bao <yuhongbao_386@hotmail.com>
CC: "mingo@kernel.org" <mingo@kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [tip:x86/smap] x86-32: Start out eflags and cr4 clean
References: <1348529239-17943-1-git-send-email-hpa@linux.intel.com>,<tip-5a5a51db78ef24aa61a4cb2ae36f07f6fa37356d@git.kernel.org> <SNT002-W1128F6F94A63B050C01347BC3590@phx.gbl>
In-Reply-To: <SNT002-W1128F6F94A63B050C01347BC3590@phx.gbl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2012 07:49 PM, Yuhong Bao wrote:
>> + * Specifically, cr4 exists if and only if CPUID exists,
>> + * which in turn exists if and only if EFLAGS.ID exists.
> This may be true for *Intel* 486 CPUs as VME was implemented at the same time as CPUID, but I am not sure that it is true for AMD 486 CPUs.
>
> Yuhong Bao 		 	   		

That is the architecture; if you know of a counterexample speak up.  "I 
am not sure" doesn't count.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

