Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab0KCR4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 13:56:07 -0400
Received: from bhuna.collabora.co.uk ([93.93.128.226]:41283 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229Ab0KCR4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 13:56:05 -0400
Message-ID: <4CD1A0E7.8050602@collabora.co.uk>
Date: Wed, 03 Nov 2010 17:50:31 +0000
From: Ian Molton <ian.molton@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100917 Icedove/3.0.8
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: virtualization@lists.linux-foundation.org, Avi Kivity <avi@redhat.com>,
        virtualization@lists.osdl.org, linux-kernel@vger.kernel.org,
        QEMU Developers <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] Re: [PATCH] Implement a virtio GPU transport
References: <4CAC9CD1.2050601@collabora.co.uk> <4CBD7560.6080207@redhat.com> <4CC8226F.5080807@collabora.co.uk> <201010292148.01167.rusty@rustcorp.com.au>
In-Reply-To: <201010292148.01167.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/10/10 12:18, Rusty Russell wrote:
> On Wed, 27 Oct 2010 11:30:31 pm Ian Molton wrote:
>> On 19/10/10 11:39, Avi Kivity wrote:
>>> On 10/19/2010 12:31 PM, Ian Molton wrote:
>>
>>>>> 2. should start with a patch to the virtio-pci spec to document what
>>>>> you're doing
>>>>
>>>> Where can I find that spec?
>>>
>>> http://ozlabs.org/~rusty/virtio-spec/
>>
>> Ok, but I'm not patching that until theres been some review.
>
> Fair enough; it's a bit of a PITA to patch, so it makes sense to get the
> details nailed down first.

I thought so :)

>> Fixed - updated patch tested and attached.
>
> OK. FWIW, I think this is an awesome idea.  I understand others are skeptical,
> but this seems simple and if it works and you're happy to maintain it I'm
> happy to let you do it :)

Awesoe, thanks Rusty :)
