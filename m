Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490Ab2JDT2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 15:28:12 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:43431 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab2JDT2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 15:28:11 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:ae16:2dff:fe07:4e83]
In-Reply-To: <506DDA31.9010503@codeaurora.org>
References: <506D4BCD.3020402@codeaurora.org>
	<CAOesGMjotnx_6HiwngRO9OaZYGGAexiwZ_shkOK7qROZcjDmqA@mail.gmail.com>
	<506DDA31.9010503@codeaurora.org>
Date: Thu, 4 Oct 2012 12:28:08 -0700
Message-ID: <CAOesGMgng=OLWT3AwWcvkDQwVAoQknJ5bdZVF__fwSD6WfbkQQ@mail.gmail.com>
Subject: Re: arm-soc maintainer entry
From: Olof Johansson <olof@lixom.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: arm@kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 4, 2012 at 11:49 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 10/04/12 09:55, Olof Johansson wrote:
>> Hi,
>>
>> On Thu, Oct 4, 2012 at 1:41 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>> Is the arm@kernel.org alias going to be added into the MAINTAINERS file?
>>> Should anybody be sending mails to this address?
>>>
>>> It seems I asked this over a year ago and the response was positive but
>>> nothing ever happened[1]. Maybe something like below? I only ask because
>>> get_maintainer.pl isn't picking up this email.
>> I've been holding off re-proposing this, mostly because life is easier
>> for us if we don't get arm@kernel.org cc:d on every single patch by
>> people who run get_maintainers.pl -- it's the equivalent of getting
>> linux-arm-kernel cc:d to your inbox. It's better signal-to-noise ratio
>> if it's mostly platform maintainers that email us on that address with
>> pull requests or patches they want applied.
>>
>> But yeah, it also means that the maintainer structure is undocumented.
>> I'm open for suggestions.
>>
>
> Thanks for clarifying. Maybe we can put in the git tree and no email
> address? That at least documents some structure.

Ah, yes, that makes a lot of sense.


-Olof
