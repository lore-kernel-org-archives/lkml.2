Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab0CYX7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 19:59:14 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62033 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab0CYX7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 19:59:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QuCjMo9HEiXGwQTc2lbUk3hHm+l33jBIekFGtAzBIZhFQzi2CWPHy42000PpnbsM9f
         F6l2aPnXzDdKaGZaGV22gN4ld/Oc+2g3euSm/JKq78m7Vf8CEVIpQ2T67okDOJeiNie5
         fxgYtjW+xMPAvarpX5KcNLgW3wFycLN7FMvAA=
MIME-Version: 1.0
In-Reply-To: <e9c3a7c21003251612l59d77753o8f56e2643a96fe0d@mail.gmail.com>
References: <4BAAD5BB.7050101@samsung.com>
	 <1b68c6791003242234h106d9530p12b5a046a906227e@mail.gmail.com>
	 <63386a3d1003250130w6f34854ag2ca163799e9b7bed@mail.gmail.com>
	 <1b68c6791003250517y4e2789baoe147e5982c363682@mail.gmail.com>
	 <4BAB7D9F.4070807@intel.com>
	 <1b68c6791003251527s1ef985d2m4a309a3c09e31e0a@mail.gmail.com>
	 <e9c3a7c21003251612l59d77753o8f56e2643a96fe0d@mail.gmail.com>
Date: Fri, 26 Mar 2010 08:59:12 +0900
Message-ID: <1b68c6791003251659w4c6c8d12rf97458c2380f25e0@mail.gmail.com>
Subject: Re: [PATCH v2] PL330: Add PL330 DMA controller driver
From: jassi brar <jassisinghbrar@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
       Joonyoung Shim <jy0922.shim@samsung.com>,
       "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Ben Dooks <ben-linux@fluff.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 8:12 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Thu, Mar 25, 2010 at 3:27 PM, jassi brar <jassisinghbrar@gmail.com> wrote:
>> On Fri, Mar 26, 2010 at 12:13 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>>> It sounds like you just need to add an extension for the arch specific dma
>>> api.
>> I actually plan more than that.
>> Apart from inefficient design, JoonYoung's driver has made some fatal
>> assumptions
>> about PL330, which will result in DMA aborts if used with SoCs that implement
>> configuration of PL330 that is very different from Samsung SoCs'
>> Of course, I address all such issues that I can think of, in my implementation.
>
> Ok, I'll rely on acked-by's from the interested parties once your
> driver is out as I do not have a vested interest in this hardware,
> just the dmaengine framework issues.
Fair enough. Thank you.
