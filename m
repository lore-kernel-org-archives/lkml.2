Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449Ab0EZQv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:51:27 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:52512 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476Ab0EZQvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:51:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Nz7ur7sJN9YCp7jSsGUTw+yNypU37P1WrYFtRQqtxe8GuTJYDGI0/SQuRB+fc/BMbR
         xCJrygib28yZpg7cXG03bldjtFIKzKKyIUGsmgP2ejPXMWMss66cMH4aC/VjTlv4Xxrn
         Fj8xYJk5a9jrHwfIiPzQYbwLfGg/ULzhfCLhE=
Message-ID: <4BFD519D.3030803@gmail.com>
Date: Wed, 26 May 2010 09:51:41 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: ath9k-devel@venema.h4ckr.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ath9k-devel] ath: Failed to stop TX DMA in 100 msec after 	killing
 last frame
References: <4BFCC813.50806@gmail.com> <AANLkTinLK5S9NcRE0fxwAqEKXndHrPj13MR-UWarKzPL@mail.gmail.com> 	<4BFD4DEC.3050101@gmail.com> <AANLkTikfr_HG0cL0CaZEQdaM1UVgbLIRsk20cvd1Jb26@mail.gmail.com>
In-Reply-To: <AANLkTikfr_HG0cL0CaZEQdaM1UVgbLIRsk20cvd1Jb26@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 09:40 AM, Luis R. Rodriguez wrote:
> On Wed, May 26, 2010 at 9:35 AM, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>    
>> On 05/26/2010 09:33 AM, Luis R. Rodriguez wrote:
>>      
>>> On Wed, May 26, 2010 at 12:04 AM, Justin P. Mattock
>>> <justinmattock@gmail.com>    wrote:
>>>
>>>        
>>>> This is new:
>>>> [ 8660.899624] ath: Failed to stop TX DMA in 100 msec after killing last
>>>> frame
>>>> [ 8660.899676] ath: Unable to stop TxDMA. Reset HAL!
>>>>
>>>> I don't have hal installed!! should I be concerned?
>>>>
>>>>          
>>> No, the print can be changed to say "reseting hardware", patch welcomed.
>>>
>>>    Luis
>>>
>>>
>>>        
>> sure!! let me fix that up, and also send you something
>> else I had kicking around..
>>      
> Sure, BTW, no need to use lkml unless you need further review, use
> instead just linux-wireless for patches/raves/rants for 802.11. In
> fact you can drop ath9k-devel when using linux-wireless.
>
>    Luis
>
>    
alright!!
(and of course after pressing "send" I get this post!!)
Anyways I'll send another patch that I was experimenting
with(just to see!!).

cheers,

Justin P. Mattock
