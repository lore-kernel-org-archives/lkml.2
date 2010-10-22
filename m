Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab0JVJ7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 05:59:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48021 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab0JVJ7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 05:59:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Qa+G08f3SVTQjlHjq1MNmVWbwEWBknuHbYqeIJgcYx4BXy4xwDs9uriLw4creHaY8e
         nhZ/mzX/TZnUTTinr7InALvig5dGk6HC8K4ESeiZH9D8vn+6gAsaPrjoAspvUXtgvU7D
         EWs/350tpQ0iz+0paH4NB+Nk9CojfVcwzPC1Q=
MIME-Version: 1.0
In-Reply-To: <AANLkTikawFKKLkT_CRw4HbeTsiSoJyd70k2e3a0F5Fr7@mail.gmail.com>
References: <1287542932-14206-1-git-send-email-x0095840@ti.com>
	<1287542932-14206-2-git-send-email-x0095840@ti.com>
	<1287542932-14206-3-git-send-email-x0095840@ti.com>
	<1287542932-14206-4-git-send-email-x0095840@ti.com>
	<1287542932-14206-5-git-send-email-x0095840@ti.com>
	<AANLkTimSQabHv3AOFFR4m3POjmuGvN18u7TNsPyauH8D@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F4935CD8@dlee06.ent.ti.com>
	<AANLkTikawFKKLkT_CRw4HbeTsiSoJyd70k2e3a0F5Fr7@mail.gmail.com>
Date: Fri, 22 Oct 2010 12:59:13 +0300
Message-ID: <AANLkTikCsBCoT55BXvSJEkKYh8M0mMLBag_MR4-aBsEk@mail.gmail.com>
Subject: Re: [PATCHv4 4/4] iommu: create new api to set valid da range
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Cc: "Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>,
        "david.cohen@nokia.com" <david.cohen@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 7:26 PM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> On Wed, Oct 20, 2010 at 6:22 PM, Guzman Lugo, Fernando
> <fernando.lugo@ti.com> wrote:
>>> On Wed, Oct 20, 2010 at 5:48 AM, Fernando Guzman Lugo
>>> <x0095840@ti.com> wrote:
>>> > Some IOMMUs cannot use the whole 0x0 - 0xFFFFFFFF range.
>>> > With this new API the valid range can be set.
>>> >
>>> > Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
>>>
>>> I don't see the point in having an API. It could be done
>>
>> Thanks to this api we can make this:
>>
>> A new kconfig parameter for DMM size is added. Also DMM is
>> allocated in the last part of the IVA MMU capable address.
>> So that DMM address are far away of shared memory address
>> reducing the probability of shared memory corruption.
>
> Ok, that's why it's usually a good idea to send a patch that makes use
> of the new API.

Oh, and some more comments: Hiroshi wanted the end address too, but
also on the platform data.

And please use a sensible prefix, like "omap: iommu: ", if you only do
"iommu: " it can be confused with other parts of the system, specially
if you send to lkml.

-- 
Felipe Contreras
