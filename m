Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab2KPTkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 14:40:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35493 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193Ab2KPTkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 14:40:07 -0500
Message-ID: <50A69684.20103@zytor.com>
Date: Fri, 16 Nov 2012 11:39:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 8/9] x86: ramdisk info print with high bits.
References: <1353055989-31939-1-git-send-email-yinghai@kernel.org> <1353055989-31939-9-git-send-email-yinghai@kernel.org> <50A6644D.80205@zytor.com> <CAE9FiQXJqyUf7qAspG_ZKUPV96QQjayp8cM0ihQ0RpyU5AxBMA@mail.gmail.com> <CAE9FiQUkWug18Bdyjp7ocJxCCJxpa7+tY0+eQ301pY1a-f+JUw@mail.gmail.com>
In-Reply-To: <CAE9FiQUkWug18Bdyjp7ocJxCCJxpa7+tY0+eQ301pY1a-f+JUw@mail.gmail.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 11:32 AM, Yinghai Lu wrote:
>>
>> or fix printk to add extra 2 for "0x" when # is found?
> 
> looks like we have lots of %#010llx or %#010Lx there in arch/x86.
> 
> We need to fix printk to make it acting like %pR ?
> 

No, it was a thinko on my part.

	-hpa

