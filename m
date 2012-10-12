Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564Ab2JLMHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 08:07:06 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61192 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759066Ab2JLMHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 08:07:05 -0400
MIME-Version: 1.0
In-Reply-To: <m2391ktxjj.fsf@firstfloor.org>
References: <CALF0-+XGn5=QSE0bpa4RTag9CAJ63MKz1kvaYbpw34qUhViaZA@mail.gmail.com>
	<m27gqwtyu9.fsf@firstfloor.org>
	<alpine.DEB.2.00.1210111558290.6409@chino.kir.corp.google.com>
	<m2391ktxjj.fsf@firstfloor.org>
Date: Fri, 12 Oct 2012 09:07:04 -0300
Message-ID: <CALF0-+WLZWtwYY4taYW9D7j-abCJeY90JzcTQ2hGK64ftWsdxw@mail.gmail.com>
Subject: Re: [Q] Default SLAB allocator
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Tim Bird <tim.bird@am.sony.com>,
        celinux-dev@lists.celinuxforum.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 11, 2012 at 8:10 PM, Andi Kleen <andi@firstfloor.org> wrote:
> David Rientjes <rientjes@google.com> writes:
>
>> On Thu, 11 Oct 2012, Andi Kleen wrote:
>>
>>> > While I've always thought SLUB was the default and recommended allocator,
>>> > I'm surprise to find that it's not always the case:
>>>
>>> iirc the main performance reasons for slab over slub have mostly
>>> disappeared, so in theory slab could be finally deprecated now.
>>>
>>
>> SLUB is a non-starter for us and incurs a >10% performance degradation in
>> netperf TCP_RR.
>

Where are you seeing that?

Notice that many defconfigs are for embedded devices,
and many of them say "use SLAB"; I wonder if that's right.

Is there any intention to replace SLAB by SLUB?
In that case it could make sense to change defconfigs, although
it wouldn't be based on any actual tests.

    Ezequiel
