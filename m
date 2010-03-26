Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab0CZBBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 21:01:52 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39558 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab0CZBBv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 21:01:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Imq+XmRg6l+7qeovqhD+gkTRl2d+o3GJWr5ZCkHlUnv0DOb4y7Qj4Mw9C33+/O8RxC
         w5DBPQa10ZXWv/fLK1xdAJD1J6prJB6BvN4fzZGh1MdwRBzbqsTaPUmQRlCz5ARylRNl
         pBYm3kLvkUEZ/8CUFPRL5GbOuJKQRWY33NdQc=
MIME-Version: 1.0
In-Reply-To: <4BAC05C7.2030208@samsung.com>
References: <4BAAD5BB.7050101@samsung.com>
	 <1b68c6791003242234h106d9530p12b5a046a906227e@mail.gmail.com>
	 <63386a3d1003250130w6f34854ag2ca163799e9b7bed@mail.gmail.com>
	 <1b68c6791003250517y4e2789baoe147e5982c363682@mail.gmail.com>
	 <4BAB7D9F.4070807@intel.com>
	 <1b68c6791003251527s1ef985d2m4a309a3c09e31e0a@mail.gmail.com>
	 <4BAC05C7.2030208@samsung.com>
Date: Fri, 26 Mar 2010 10:01:49 +0900
Message-ID: <1b68c6791003251801w9cc44blb8a9258e93632ce5@mail.gmail.com>
Subject: Re: [PATCH v2] PL330: Add PL330 DMA controller driver
From: jassi brar <jassisinghbrar@gmail.com>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
       Linus Walleij <linus.ml.walleij@gmail.com>,
       "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Ben Dooks <ben-linux@fluff.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 9:54 AM, Joonyoung Shim <jy0922.shim@samsung.com> wrote:
> On 3/26/2010 7:27 AM, jassi brar wrote:
>> On Fri, Mar 26, 2010 at 12:13 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>>> jassi brar wrote:
>>>>> Perhaps Joonyoung can simply port over the stuff
>>>>> you need to this driver if you show your code.
>>>> Having worked on Samsung SoCs(with PL330 DMAC) based products, I would be
>>>> _very_ surprised if any user found this implementation useful.
>>>> Let alone testing, this implementation can't even explain usability
>>>> for fast peripherals
>>>> with shallow FIFOs. I didn't give feedback for this patch because I am
>>>> not sure if this
>>>> is the right way to go at all.
>>> This is the wrong attitude. 혻If it were not for a simple oversight
>>> Joonyoung's driver would already be upstream for the past two kernel
>>> releases. 혻So you need to work together to improve that driver to
>>> incorporate what you need.
>> Nothing wrong in attitude here.
>> Giving feedback on the code only comes after one is convinced with the
>> overall approach taken. The last time I raised the PL330 driver issue,
>> most people were not enthusiastic with this drivers/dma/ approach.
>> I wasn't active mainline discussions when the driver was originally
>> submitted a few months ago.
>> And now my replies are not very 'polite' because theres a lot going on
>> in the background that people in public threads don't know about.
>>
>>
>>> It sounds like you just need to add an extension for the arch specific dma
>>> api.
>> I actually plan more than that.
>> Apart from inefficient design, JoonYoung's driver has made some fatal
>> assumptions
>> about PL330, which will result in DMA aborts if used with SoCs that implement
>> configuration of PL330 that is very different from Samsung SoCs'
>> Of course, I address all such issues that I can think of, in my implementation.
>>
>
> I can wait your implementation and wonder what is the issue also.
>
> I welcome you try other design and want better driver is committed at
> mainline kernel too.
Good to have you at last reply to my posts
