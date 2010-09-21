Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab0IUSGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 14:06:09 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50231 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab0IUSGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 14:06:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=aUJfwK/4Oh6iNRdOCihQlfMpSl3gqdxKjsHSYNj8VZhPBTGHEyTWhxVRI5RuL/n22P
         wKuwPU3KGOG0YgfMx82rPwHz76WfJ+hsV0BZP8g3GtIwhsrPZlwu35ygNWSzVqTsamfe
         Z8NtMAjoAS56Ltwg1kz6aAgP/kv3TpQo5E3Wc=
MIME-Version: 1.0
In-Reply-To: <20100921173719.GA11404@suse.de>
References: <19F8576C6E063C45BE387C64729E7394046836CB57@dbde02.ent.ti.com>
	<20100831041114.GA16009@suse.de>
	<19F8576C6E063C45BE387C64729E7394046836CE5C@dbde02.ent.ti.com>
	<20100831224238.GA13253@suse.de>
	<19F8576C6E063C45BE387C64729E739404687B2835@dbde02.ent.ti.com>
	<AANLkTimCkTFfe157dHK=caAdAeX_4m1A_p6ZRxp=2RWt@mail.gmail.com>
	<19F8576C6E063C45BE387C64729E739404687B2B27@dbde02.ent.ti.com>
	<AANLkTimZ2Pe5T2=ZUZnd_3-RQi8Qs4FrykkJy6Zvx89M@mail.gmail.com>
	<19F8576C6E063C45BE387C64729E739404687B2B81@dbde02.ent.ti.com>
	<AANLkTim0Z7AWeqCM4d26Z1UP1VsEaSBgqDCAUr1vqgMj@mail.gmail.com>
	<20100921173719.GA11404@suse.de>
Date: Tue, 21 Sep 2010 21:06:07 +0300
Message-ID: <AANLkTim1cjcXf+eB7O9cTfEu1s=+-eL3uZ=UcXvb8H4M@mail.gmail.com>
Subject: Re: [PATCH] drivers:staging:ti-st: remove st_get_plat_device
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: "Savoy, Pavan" <pavan_savoy@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> see here:
>> http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.36-rc5-maverick/0002-DISABLE-ti-st.patch
>>
>> I know you are overburned. Just get 1 or 2 guys to teach them to help you.
>
> I still don't understand, what does that patch have to do with the
> staging tree?
>
> thanks,
>
> greg k-h
>

In Ubuntu, the ti-st driver have a problem at the building time.
