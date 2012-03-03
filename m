Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab2CCSry (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 13:47:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51552 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab2CCSrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 13:47:53 -0500
Message-ID: <4F52674F.3010508@zytor.com>
Date: Sat, 03 Mar 2012 10:47:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Word-at-a-time dcache name accesses
References: <alpine.LFD.2.02.1203021544300.28247@i5.linux-foundation.org> <4F516811.8060800@zytor.com> <m2eht964ud.fsf@firstfloor.org>
In-Reply-To: <m2eht964ud.fsf@firstfloor.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2012 08:12 AM, Andi Kleen wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
>> On 03/02/2012 03:46 PM, Linus Torvalds wrote:
>>>
>>> Comments?
>>>
>>
>> My biggest concern is what happens when this happens to be at the end of
>> mapped kernel memory and we overrun the page?
> 
> A long time ago (AMD K7ish) we had hardware bugs to work around in
> this area. Overlapping into some PCI hole MMIO areas could cause obscure
> hangs.  That is why I was always careful to not do that in any x86
> library code.
> 

We still map too much, though.  That's a separate problems which should
be fixed in its own right, though.

	-hpa


