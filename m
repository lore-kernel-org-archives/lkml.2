Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126Ab0IURey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 13:34:54 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41466 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab0IURew convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 13:34:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aZ3UrJgnwSVpOqwqzd9tSqix1DQeK6gJ6jZlxvk3y4oRfB6HICqO28rQwrdSmGWeZC
         2R/fign0QTpB3cUScoYMhm8hYTgn7LQNbEk8EYrBwWhSi9RzHjIn+4DhbTOBmOqSKQYi
         ud9CfJDpL9d50jdK1+xeWCO+UXx24X9xsccZI=
MIME-Version: 1.0
In-Reply-To: <19F8576C6E063C45BE387C64729E739404687B2B81@dbde02.ent.ti.com>
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
	<AANLkTimZ2Pe5T2=ZUZnd_3-RQi8Qs4FrykkJy6Zvx89M@mail.gmail.com>
	<19F8576C6E063C45BE387C64729E739404687B2B81@dbde02.ent.ti.com>
Date: Tue, 21 Sep 2010 20:34:51 +0300
Message-ID: <AANLkTim0Z7AWeqCM4d26Z1UP1VsEaSBgqDCAUr1vqgMj@mail.gmail.com>
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

> It is currently in linux-next.
[...]
>> >> Build error (kernel 2.6.36-rc3-git1):
>> >>
>> >>
>> >> Building modules, stage 2.
>> >>   MODPOST 3056 modules
>> >> ERROR: "st_get_plat_device" [drivers/staging/ti-st/st_drv.ko] undefined!

Greg,

you send some pull requests to Linus.
Can you compile the kernel without this patch ?

see here:
http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.36-rc5-maverick/0002-DISABLE-ti-st.patch

I know you are overburned. Just get 1 or 2 guys to teach them to help you.
