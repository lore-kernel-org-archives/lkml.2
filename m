Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab1D1Ite (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 04:49:34 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63392 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab1D1Itc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 04:49:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wMd0nZMg/f9VKGOUAsFAb8HXpjeOK4Q0oIM9+IrQtJte4GLxa8JcAHghNRpj5gXTCe
         8nndEnobw1QHhCudDMEVkgqJmBPpGGA4hYQKd/4Sr0KOcFFlMp0vGJrR52JlguODhpcv
         4D1njJFjxZJ8yeUyuEzQ0y+97cB7O6nZ1W/Sk=
MIME-Version: 1.0
In-Reply-To: <20110427130904.47331a9f@lxorguk.ukuu.org.uk>
References: <1303882625-28115-1-git-send-email-lifongsun@gmail.com>
	<20110427130904.47331a9f@lxorguk.ukuu.org.uk>
Date: Thu, 28 Apr 2011 16:49:31 +0800
Message-ID: <BANLkTikLUssAMHBkPmwKFZja6OMDih_DKQ@mail.gmail.com>
Subject: Re: [PATCH] Applying inappropriate ioctl operation on socket should
 return ENOTTY
From: Lifeng Sun <lifongsun@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 8:09 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> diff --git a/drivers/char/viotape.c b/drivers/char/viotape.c
>> index ad6e64a..a427d40 100644
>> --- a/drivers/char/viotape.c
>> +++ b/drivers/char/viotape.c
>> @@ -529,7 +529,7 @@ static int viotap_ioctl(struct inode *inode, struct file *file,
>>
>>       down(&reqSem);
>>
>> -     ret = -EINVAL;
>> +     ret = -ENOTTY;
>
> Again this messes up the returns because code assumes the initial
> default.

> The original code also has bugs too (wrong error off
> copy_*_user() again)

It seems alright.

- Lifeng
