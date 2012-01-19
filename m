Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab2ASO4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 09:56:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36558 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab2ASO4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 09:56:11 -0500
Message-ID: <4F182EE8.2030308@zytor.com>
Date: Thu, 19 Jan 2012 06:55:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: mingo@elte.hu, "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        tglx@linutronix.de, luca@luca-barbieri.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ix86: atomic64 assembly improvements
References: <4F16E41B020000780006D7A5@nat28.tlf.novell.com> <4F16F505.8040809@zytor.com> <4F170679020000780006D85B@nat28.tlf.novell.com> <4F1705A8.301@zytor.com> <4F17EDE9020000780006D97A@nat28.tlf.novell.com> <4F182C55.7040305@zytor.com> <4F183BCA020000780006DB68@nat28.tlf.novell.com>
In-Reply-To: <4F183BCA020000780006DB68@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2012 06:50 AM, Jan Beulich wrote:
>>
>> It doesn't have anything to do with caches on or off.
>
> How does it not? If any part of the bus topology is only 32 bits wide,
> a 64-bit read or write simply can't be executed atomically without
> asserting LOCK#.
>

If any part of the bus topology is only 32 bits wide, you're not talking 
to memory on anything newer than a 486.

LOCK to I/O devices is unreliable on any machine (a lot of northbridges 
simply drop LOCK on the floor).

	-hpa

