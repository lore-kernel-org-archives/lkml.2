Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab2DZOvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 10:51:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38383 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806Ab2DZOvp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 10:51:45 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1204260203160.2542@ionos>
References: <1335396750-18950-1-git-send-email-krzysztof.wilczynski@linux.com> <alpine.LFD.2.02.1204260203160.2542@ionos>
From: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
Date: Thu, 26 Apr 2012 15:51:04 +0100
X-Google-Sender-Auth: v6GTsU1LUOLU6r1UhyRuXE8-ux4
Message-ID: <CAC52Y8aANVqE5J7faKWSb5KuuDEaEbSK-nC6DUHowDMEWTn6iw@mail.gmail.com>
Subject: Re: [PATCH][TRIVIAL] mfd: twl6030: Add intermediate cast to uintptr_t
 before casting to pointer.
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 26 April 2012 01:06, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 26 Apr 2012, Krzysztof Wilczynski wrote:
>
>> This is to address the following warning during compilation time:
>>
>>   drivers/mfd/twl6030-irq.c: In function ‘twl6030_init_irq’:
>>   drivers/mfd/twl6030-irq.c:398: warning: cast to pointer from integer of different size
>>   drivers/mfd/twl6030-irq.c:415: warning: cast to pointer from integer of different size
>
> Sigh. Instaed of blindy fixing some random warning, that driver should
> be converted to use proper threaded interrupt handlers which already
> do the Right Thing.

Thank you for pointing this out to me :)  I was not aware that it has
to be converted to use new API / functionality.  I will most certainly
look how to do this and what is required to do so.

KW
