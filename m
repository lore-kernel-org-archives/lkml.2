Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab0LHPXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 10:23:07 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:51447 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab0LHPXF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 10:23:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wjsyOkr/F1xvVJ/fOGkQ9pvnDUED81VoPCGQ9Mj/oK3iIL+MM/dQqX8RwxXkw1o98o
         fqxUqRV5yglUSsYqItgtwKFex7jbOfCAyIL8tax4ZXJk9qKHi34Stl6UFvba8iPsIPnc
         f3BdccIkkSOcncObuKGB1vpcj5UEI61cDbPIM=
MIME-Version: 1.0
In-Reply-To: <241570.15232.qm@web31708.mail.mud.yahoo.com>
References: <712019.56679.qm@web31702.mail.mud.yahoo.com>
	<4CFEE38E.3020500@gmail.com>
	<597621.83948.qm@web31707.mail.mud.yahoo.com>
	<AANLkTi=V_MD5MqkPfBSD0P+J0vYgS3nwHZA37SOvYW-Z@mail.gmail.com>
	<241570.15232.qm@web31708.mail.mud.yahoo.com>
Date: Wed, 8 Dec 2010 09:23:04 -0600
Message-ID: <AANLkTikx314joTYUBeEequWCbiv7rAdSeZaUv1zn=Ags@mail.gmail.com>
Subject: Re: Posted Write onto a PCI end point device using Linux
From: Robert Hancock <hancockrwd@gmail.com>
To: Sanka Piyaratna <cesanka@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 12:05 AM, Sanka Piyaratna <cesanka@yahoo.com> wrote:
> Thanks for that Robert. When you say DMA, this has to be implemented at the
> endpoint device doesn't it? There is no DMA mode on the CPU for doing this is
> there?

No, there's not (on typical hardware, anyway).

>
>  Sanka Piyaratna
>
>
>
>
> ________________________________
> From: Robert Hancock <hancockrwd@gmail.com>
> To: Sanka Piyaratna <cesanka@yahoo.com>
> Cc: linux-kernel@vger.kernel.org
> Sent: Wed, 8 December, 2010 3:25:47 PM
> Subject: Re: Posted Write onto a PCI end point device using Linux
>
> On Tue, Dec 7, 2010 at 9:57 PM, Sanka Piyaratna <cesanka@yahoo.com> wrote:
>> Hi Robert,
>> Could you please tell me how I can initiate a posted write towards a PCIe
>> endpoint with larger than 32 bit payload using Linux?
>> Thanks and regards,
>
> You can try writeq to get a 64-bit payload, but I don't think it's
> available on all platforms. In particular with a 32-bit CPU, it may
> not be possible at all. If you need to send bigger payloads then you
> need to use DMA.
>
>>
>> Sanka Piyaratna
>>
>> ________________________________
>> From: Robert Hancock <hancockrwd@gmail.com>
>> To: Sanka Piyaratna <cesanka@yahoo.com>
>> Cc: linux-kernel@vger.kernel.org
>> Sent: Wed, 8 December, 2010 12:16:54 PM
>> Subject: Re: Posted Write onto a PCI end point device using Linux
>>
>> On 12/07/2010 05:29 AM, Sanka Piyaratna wrote:
>>> Hi,
>>>
>>>
>>> I am wondering whether it is possible to issue a posted write using the
>>> host
>>> computer's root complex towards an PCI express end point. I have done this
>>> using
>>>
>>> DMA in the past. However, if posted writes are possible that would save a
>>> lot of
>>>
>>> time and effort and would be quicker too.
>>
>> Writes from the CPU to PCI memory are always posted. However, the posted
>> write buffer size is usually quite limited and so this probably will
>> still cause CPU overhead when writing any significant amount of data
>> this way.
>>
>>
>
>
>
>
>
