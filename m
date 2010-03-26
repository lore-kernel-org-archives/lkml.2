Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab0CZAaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 20:30:00 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34076 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab0CZA36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 20:29:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=YWLpFom2zmlC8RAI1XqcKqdvtHYWx+q/1cENCuuZVKGA+gXFnLiwFQmsXq1x4oqbrt
         JjtprtooTIqHcYYfr5BTeVmQQCSA0QCFDkTGDm2ncgie82w2CnNaJQ8w9T4J/ryJeLc7
         BLa93iMi2U3/eHAWM1kO+ovtiATkg/T2COvh8=
MIME-Version: 1.0
In-Reply-To: <1b68c6791003251659w4c6c8d12rf97458c2380f25e0@mail.gmail.com>
References: <4BAAD5BB.7050101@samsung.com>
	 <1b68c6791003242234h106d9530p12b5a046a906227e@mail.gmail.com>
	 <63386a3d1003250130w6f34854ag2ca163799e9b7bed@mail.gmail.com>
	 <1b68c6791003250517y4e2789baoe147e5982c363682@mail.gmail.com>
	 <4BAB7D9F.4070807@intel.com>
	 <1b68c6791003251527s1ef985d2m4a309a3c09e31e0a@mail.gmail.com>
	 <e9c3a7c21003251612l59d77753o8f56e2643a96fe0d@mail.gmail.com>
	 <1b68c6791003251659w4c6c8d12rf97458c2380f25e0@mail.gmail.com>
Date: Fri, 26 Mar 2010 09:29:56 +0900
X-Google-Sender-Auth: 230bc72aca1f678a
Message-ID: <9c9fda241003251729y28ccbadfs7ac72ad99b6d6ffa@mail.gmail.com>
Subject: Re: [PATCH v2] PL330: Add PL330 DMA controller driver
From: Kyungmin Park <kyungmin.park@samsung.com>
To: jassi brar <jassisinghbrar@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Joonyoung Shim <jy0922.shim@samsung.com>,
       Linus Walleij <linus.ml.walleij@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ben Dooks <ben-linux@fluff.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 8:59 AM, jassi brar <jassisinghbrar@gmail.com> wrote:
> On Fri, Mar 26, 2010 at 8:12 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>> On Thu, Mar 25, 2010 at 3:27 PM, jassi brar <jassisinghbrar@gmail.com> wrote:
>>> On Fri, Mar 26, 2010 at 12:13 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>>>> It sounds like you just need to add an extension for the arch specific dma
>>>> api.
>>> I actually plan more than that.
>>> Apart from inefficient design, JoonYoung's driver has made some fatal
>>> assumptions
>>> about PL330, which will result in DMA aborts if used with SoCs that implement
>>> configuration of PL330 that is very different from Samsung SoCs'
Exactly what? We are already tested it our board and play the music well.
What's condition DMA aborts are happen?
>>> Of course, I address all such issues that I can think of, in my implementation.
>>
>> Ok, I'll rely on acked-by's from the interested parties once your
>> driver is out as I do not have a vested interest in this hardware,
>> just the dmaengine framework issues.
> Fair enough. Thank you.

As your previous mail, we can wait until this weekend. but If you
don't post the your codes until this weekend.
We assume that your works are not yet done so merge this patch first
and then fix it if your words(DMA aborts issue) are right.

Thank you,
Kyungmin Park
