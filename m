Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab2IXUcD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 16:32:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56759 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757923Ab2IXUcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 16:32:01 -0400
Message-ID: <5060C330.1000407@zytor.com>
Date: Mon, 24 Sep 2012 13:31:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Linda Wang <lwang@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 00/11] x86: Supervisor Mode Access Prevention
References: <1348256595-29119-1-git-send-email-hpa@linux.intel.com> <20120921220818.GA30959@redhat.com> <505CE5C8.80007@linux.intel.com> <20120922113226.GA3257@gmail.com>
In-Reply-To: <20120922113226.GA3257@gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2012 04:32 AM, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@linux.intel.com> wrote:
> 
>> On 09/21/2012 03:08 PM, Dave Jones wrote:
>>>
>>> Perhaps add a printk somewhere to show that it's actually been enabled maybe ?
>>>
>>> Also, would it be feasible to add something like we have for test_nx ?
>>> If this feature regresses in some way in the future, I suspect we'd like
>>> to know about it sooner rather than later.
>>
>> Good idea... should add this both for SMEP and SMAP.
> 
> Very much agreed - these exploit preventation hardware features 
> are really useful, and it's good to inform the user that they 
> are active.
> 

I was thinking about this, do you think a printk would be better, or a
new field in /proc/cpuinfo?

	-hpa
