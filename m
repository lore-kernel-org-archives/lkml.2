Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab0IHTD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 15:03:26 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52505 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab0IHTDV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 15:03:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DQfBqBHG2qrkjxaS4w6wmwzlAbWWIzMGrrwL3hjSRaynNc3RHY/RlLUTGc52fmM+BW
         u1PIsXdH4gTQvLwxdB0pJKQv6ufSa1y4w7afoNNRbjiw7qcx9GGnOujxQrWH7TA4sXsF
         Ig/x1dfY270t/VAMIlVZY6Ea735WV3CznRsK8=
MIME-Version: 1.0
In-Reply-To: <19F8576C6E063C45BE387C64729E739404687B2B27@dbde02.ent.ti.com>
References: <1282241331-5178-1-git-send-email-pavan_savoy@ti.com>
	<4C6D6A9A.3010409@oracle.com>
	<19F8576C6E063C45BE387C64729E7394044F124F7B@dbde02.ent.ti.com>
	<4C6D6BCB.2090307@oracle.com>
	<AANLkTi==HVhXcS0Mxv4GJL1rB0nLc3YQ=b5RbzM0iFwG@mail.gmail.com>
	<20100822033248.GA4886@suse.de>
	<19F8576C6E063C45BE387C64729E7394046836CB57@dbde02.ent.ti.com>
	<20100831041114.GA16009@suse.de>
	<19F8576C6E063C45BE387C64729E7394046836CE5C@dbde02.ent.ti.com>
	<20100831224238.GA13253@suse.de>
	<19F8576C6E063C45BE387C64729E739404687B2835@dbde02.ent.ti.com>
	<AANLkTimCkTFfe157dHK=caAdAeX_4m1A_p6ZRxp=2RWt@mail.gmail.com>
	<19F8576C6E063C45BE387C64729E739404687B2B27@dbde02.ent.ti.com>
Date: Wed, 8 Sep 2010 22:03:19 +0300
Message-ID: <AANLkTimZ2Pe5T2=ZUZnd_3-RQi8Qs4FrykkJy6Zvx89M@mail.gmail.com>
Subject: Re: [PATCH] drivers:staging:ti-st: remove st_get_plat_device
From: Anca Emanuel <anca.emanuel@gmail.com>
To: "Savoy, Pavan" <pavan_savoy@ti.com>
Cc: Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, this patch is not in your tree.

please fix this.

On Wed, Sep 8, 2010 at 5:39 PM, Savoy, Pavan <pavan_savoy@ti.com> wrote:
> Emanuel,
>
> I've recently posted a patch to solve this problem.
> Patch @ http://lkml.org/lkml/2010/8/19/238
>
> PS: In fact it is strange that you replied to the same thread which is supposed to solve the problem.
>
> Thanks...
>
>> -----Original Message-----
>> From: Anca Emanuel [mailto:anca.emanuel@gmail.com]
>> Sent: Wednesday, September 08, 2010 1:27 AM
>> To: Savoy, Pavan
>> Cc: Greg KH; linux-kernel@vger.kernel.org; devel@driverdev.osuosl.org
>> Subject: Re: [PATCH] drivers:staging:ti-st: remove st_get_plat_device
>>
>> Build error (kernel 2.6.36-rc3-git1):
>>
>>
>> Building modules, stage 2.
>>   MODPOST 3056 modules
>> ERROR: "st_get_plat_device" [drivers/staging/ti-st/st_drv.ko] undefined!
>
