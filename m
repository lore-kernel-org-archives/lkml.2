Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab2CYO4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 10:56:18 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50705 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118Ab2CYO4Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 10:56:16 -0400
MIME-Version: 1.0
In-Reply-To: <20120325004232.AD9793E0409@localhost>
References: <1332581257-15989-1-git-send-email-thomas.abraham@linaro.org>
	<4F6DC847.8000902@gmail.com>
	<20120325004232.AD9793E0409@localhost>
Date: Sun, 25 Mar 2012 20:26:15 +0530
Message-ID: <CAJuYYwTjqdSAXBr6c+da85dSxRM5_-L=54RkBo1eJt9Jn=sCXw@mail.gmail.com>
Subject: Re: [PATCH] of/irq: add empty irq_of_parse_and_map() for non-dt builds
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robherring2@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        patches@linaro.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 March 2012 06:12, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Sat, 24 Mar 2012 08:12:39 -0500, Rob Herring <robherring2@gmail.com> wrote:
>> On 03/24/2012 04:27 AM, Thomas Abraham wrote:
>> > Add a empty irq_of_parse_and_map() that returns 0 for non-dt builds and
>> > avoid having #ifdef CONFIG_OF around all calls to irq_of_parse_and_map().
>> >
>> > Suggested-by: Grant Likely <grant.likely@secretlab.ca>
>> > Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
>> > ---
>>
>> Acked-by: Rob Herring <rob.herring@calxeda.com>
>>
>> Go ahead and merge with the rest of your series.
>
> Actually, it's not quite fully baked; the forward declaration of
> irq_of_parse_and_map() needs to be moved under the #if
> defined(CONFIG_OF_IRQ) block (just move the #if statement up 7 lines).
> After doing that you can add my acked-by and merge it with the rest of
> your series.  There is no sense merging it through my tree when you
> are the only user depending on it.
>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>

Thanks. I will do that change which you have suggested and take it
through the Samsung tree. But I was thinking that if it goes through
your tree, there would be less chances of a merge conflict in
include/linux/of_irq.h, a file that might see updates from other
sources.

Thanks,
Thomas.
