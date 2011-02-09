Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab1BILQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 06:16:42 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34726 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab1BILQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 06:16:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=xe8meJBm7pS7y/aaB1dm+/EoMGkSwQgqS7PneNa7su6QT1Q5nuPativet2f55LYn1w
         zVsajtoood+y8a4YZnrmOtyI/It97EygxF0CuvczGCyKG4nLfMNbiJ1DXdC2l6yPctOC
         6ojZmYEIws3OXfISHhUwztXQIVLgNb+Q7RqD8=
MIME-Version: 1.0
In-Reply-To: <20110209110834.GY4384@bicker>
References: <1296042555-29145-1-git-send-email-marek.belisko@open-nandra.com>
	<1296042555-29145-4-git-send-email-marek.belisko@open-nandra.com>
	<20110126130718.GN2721@bicker>
	<20110126143045.GP2721@bicker>
	<AANLkTi=ygn3Go7kCYe1fAo6OrKQaVVGaV_=xMgxM=u5s@mail.gmail.com>
	<20110208163531.GO4384@bicker>
	<AANLkTi=u1M1Gu1y7kmaPSTd4CDUWkgowYLpQRSpwRyEY@mail.gmail.com>
	<20110209110834.GY4384@bicker>
Date: Wed, 9 Feb 2011 12:16:38 +0100
Message-ID: <AANLkTimUdPAWLZXKJZ+NPDSqi4npfxBV9WBmNd6ZbrQf@mail.gmail.com>
Subject: Re: [PATCH 4/5] staging: ft1000: Fix coding style in write_blk_fifo() function.
From: Belisko Marek <marek.belisko@gmail.com>
To: Dan Carpenter <error27@gmail.com>, Belisko Marek <marek.belisko@gmail.com>,
        Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 9, 2011 at 12:08 PM, Dan Carpenter <error27@gmail.com> wrote:
> On Wed, Feb 09, 2011 at 11:07:19AM +0100, Belisko Marek wrote:
>> Well I test it and it seems very strange and can't figure out why.
>> Will remove all byte_length manipulations and device doesn't boot properly
>> (finish with error). Add some prinkt to code figure out following:
>>
>> 1. byte_length = word_length *4 is < 64 we need to send via usb 68
>> bytes (despite
>> 4 bytes are behind 64 (without this it can't boot).
>>
>> 2. also when e.g. word_length is 400 (400*4 = 1600) condition
>> 1600%64 == 0 is valid and we send 1604 bytes to usb (also not sure why
>> but without this change it also doesn't work).
>>
>
> Huh.  Strange.  Thanks for testing.  Sorry for the noise.
No problem ;). Thanks for reviewing and making noise ;).
@greg: could you please apply posted patch(thanks):
http://driverdev.linuxdriverproject.org/pipermail/devel/2011-February/011942.html
>
> regards,
> dan carpenter
>
>
>

thanks,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
