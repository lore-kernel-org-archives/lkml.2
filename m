Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675Ab0KANFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 09:05:47 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64796 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757649Ab0KANFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 09:05:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=WHBk2Cy2hvrscNt5wt2ViRPl0uFrxSiN80TVm4a9JO5DlS0s9c3uCzQTNOdeOn+yV0
         N/yMfxsspvfu0HoH+sPNu84f4vKUNH7LoP+aIzRvR7KuNKJvETbF7BIJYN7JyPJaxSzy
         pDbSyrx4R0ue8lfuGpeHFB/JD2wWDPCupRNlY=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
In-Reply-To: <AANLkTinQ9NdEU+dp35sKp8u1tFu2NR2iX59wi-3wBFeH@mail.gmail.com>
References: <AANLkTimE4QR+=eXfSMQ5s3OvnLU0Z=7uR1vtokpLnj7X@mail.gmail.com>
	<20101101121608.GA10052@verge.net.au>
	<AANLkTinQ9NdEU+dp35sKp8u1tFu2NR2iX59wi-3wBFeH@mail.gmail.com>
Date: Mon, 1 Nov 2010 13:05:43 +0000
Message-ID: <AANLkTim=4GBFzMiAaGbs6uWbi1g2ZQGRYR55i4bO0X49@mail.gmail.com>
Subject: Re: Where can I find -rc kernels?
From: trapDoor <trapdoor6@gmail.com>
To: Ramya Desai <ramya.desai@gmail.com>
Cc: Simon Horman <horms@verge.net.au>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 12:54 PM, Ramya Desai <ramya.desai@gmail.com> wrote:
> On Mon, Nov 1, 2010 at 5:46 PM, Simon Horman <horms@verge.net.au> wrote:
>>
>> Is this what you are after?
>>
>> http://www.kernel.org/pub/linux/kernel/v2.6/testing/
>
> Simon,
>
> I did not find the complete sources in that link. I need complete
> sources by which I can build the kernel images. OR Is there any
> procedure for merging these changes into any stable kernel version
> (2.6.36) for making it 2.6.37-rc1.
>
> Thanks and Regards,
> Ramya.

I guess It just hasn't been published there yet. Not present in git
tree either - I still have 2.6.36-09871-g3985c7c and 'git pull' says:
Already up-to-date.


-- 
Thanks,
Tomasz
