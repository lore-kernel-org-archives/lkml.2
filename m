Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935333Ab2JXR3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:29:22 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:55447 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932947Ab2JXR3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:29:18 -0400
MIME-Version: 1.0
In-Reply-To: <5087FC97.6080100@parallels.com>
References: <1351087158-8524-1-git-send-email-glommer@parallels.com>
	<1351087158-8524-2-git-send-email-glommer@parallels.com>
	<0000013a932d456c-8f0cbbce-e3f7-4f2a-b051-7b093a8cfc7e-000000@email.amazonses.com>
	<5087FC97.6080100@parallels.com>
Date: Thu, 25 Oct 2012 02:29:17 +0900
Message-ID: <CAAmzW4O=0aWDzTO6qcq_vAnCfuT1y=S+iiBmi_jDVAZo45H8hA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] kmem_cache: include allocators code directly into slab_common
From: JoonSoo Kim <js1304@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Christoph Lameter <cl@linux.com>, andi@firstfloor.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/24 Glauber Costa <glommer@parallels.com>:
> On 10/24/2012 06:29 PM, Christoph Lameter wrote:
>> On Wed, 24 Oct 2012, Glauber Costa wrote:
>>
>>> Because of that, we either have to move all the entry points to the
>>> mm/slab.h and rely heavily on the pre-processor, or include all .c files
>>> in here.
>>
>> Hmm... That is a bit of a radical solution. The global optimizations now
>> possible with the new gcc compiler include the ability to fold functions
>> across different linkable objects. Andi, is that usable for kernel builds?
>>
>
> In general, it takes quite a lot of time to take all those optimizations
> for granted. We still live a lot of time with multiple compiler versions
> building distros, etc, for quite some time.
>
> I would expect the end result for anyone not using such a compiler to be
> a sudden performance drop when using a new kernel. Not really pleasant.

I agree with Glauber's opinion.
And patch looks fine to me.
