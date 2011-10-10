Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab1JJNn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:43:26 -0400
Received: from smtp-out.google.com ([74.125.121.67]:51365 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab1JJNnW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:43:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=oOUjZako/Pi7J9OXu9gUuzDg5Rd5ZMYDgghIaGpZ8BigHE2LnGnE3SEPzA6IGmQnx
	9mHxH9ge4yyqqvv0UaSqw==
MIME-Version: 1.0
In-Reply-To: <CAHFNz9+pQX8O6FAOpiNVDJbn82i7VWv6hBr6+6E_9QnvuAUGEw@mail.gmail.com>
References: <CAHFNz9L-WDeEGx9MazTawJF-Hsz88FS7Z=RinfrKn780jBf++A@mail.gmail.com>
 <CAErSpo6CH-FHOughZu3KSsRYHX2dvncB1sFBNVp+ivEHNs52yA@mail.gmail.com> <CAHFNz9+pQX8O6FAOpiNVDJbn82i7VWv6hBr6+6E_9QnvuAUGEw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 10 Oct 2011 07:42:59 -0600
Message-ID: <CAErSpo5560NJwgDSpevKNpBUALtBY=eVWkxjAkR9hv3XyH4+1g@mail.gmail.com>
Subject: Re: Memory at xxxxxx [disabled]
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 8, 2011 at 12:14 PM, Manu Abraham <abraham.manu@gmail.com> wrote:
> On 10/8/11, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Sat, Oct 8, 2011 at 9:51 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
>>> Hi,
>>>
>>> Any Idea why I am seeing the [disabled] for the specified memory
>>> region as described below ?
>>>
>>> 04:07.0 Multimedia controller [0480]: Twinhan Technology Co. Ltd
>>> Device [1822:4e31] (rev 01)
>>>        Subsystem: Twinhan Technology Co. Ltd Device [1822:0010]
>>>        Flags: medium devsel, IRQ 11
>>>        Memory at fd900000 (32-bit, prefetchable) [disabled] [size=4K]
>>
>> The complete dmesg log should have some clues.  Normally we use the
>> resources assignments done by BIOS.
>
>
> While waiting for a reply, I did a few reboots down the lane, no
> changes made by me, except that I plugged the card into the next PCI
> slot ..
>
> I am abit more perplexed now .. The device doesn't show "disabled" but
> shows a different device ID which is the correct one, as you can see,
> compared to earlier ..

The device ID issue is beyond my knowledge.  My guess is that your
device is flaky.

I might be able to help with the resource problem if you collect the
entire dmesg log.
