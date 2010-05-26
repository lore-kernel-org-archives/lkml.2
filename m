Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab0EZQs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:48:26 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:39974 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab0EZQsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:48:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=QWc2aPjkKaFHKGl6r86/ZLPRXNzIenvp95Y35oakFqRjWUVfE1FPRWtmUtW+mSSJbu
         t8ZluVNTS4ORuohvxTmltQuw4z1wsGjdWZgSYwra8KzxD//4gccOb77Ko1E05f0eviiy
         zklDMW7SChMqpMr9i/pq+wUGrG+MQu0xhXisE=
MIME-Version: 1.0
In-Reply-To: <4BFD4DEC.3050101@gmail.com>
References: <4BFCC813.50806@gmail.com> <AANLkTinLK5S9NcRE0fxwAqEKXndHrPj13MR-UWarKzPL@mail.gmail.com> 
	<4BFD4DEC.3050101@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 26 May 2010 09:40:23 -0700
Message-ID: <AANLkTikfr_HG0cL0CaZEQdaM1UVgbLIRsk20cvd1Jb26@mail.gmail.com>
Subject: Re: [ath9k-devel] ath: Failed to stop TX DMA in 100 msec after 
	killing last frame
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: ath9k-devel@venema.h4ckr.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 9:35 AM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> On 05/26/2010 09:33 AM, Luis R. Rodriguez wrote:
>>
>> On Wed, May 26, 2010 at 12:04 AM, Justin P. Mattock
>> <justinmattock@gmail.com>  wrote:
>>
>>>
>>> This is new:
>>> [ 8660.899624] ath: Failed to stop TX DMA in 100 msec after killing last
>>> frame
>>> [ 8660.899676] ath: Unable to stop TxDMA. Reset HAL!
>>>
>>> I don't have hal installed!! should I be concerned?
>>>
>>
>> No, the print can be changed to say "reseting hardware", patch welcomed.
>>
>>   Luis
>>
>>
>
> sure!! let me fix that up, and also send you something
> else I had kicking around..

Sure, BTW, no need to use lkml unless you need further review, use
instead just linux-wireless for patches/raves/rants for 802.11. In
fact you can drop ath9k-devel when using linux-wireless.

  Luis
