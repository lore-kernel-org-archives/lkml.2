Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab0ILHD0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 03:03:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48969 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab0ILHDY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 03:03:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AQkmOWycZX5Vv3tlI6LCCv6ndbqajmQbnYIinx4Orbj5EQ9wEXAHT7s/ROKF0+wubc
         L5j8Hcmgbqu8E8KdOvTfXVzDBeuNVvmK8LGO6S+hl8+XJ2hn/mvZZNDliBfe+pJpPEzf
         H9R8+YofrCyIeqyUWVp0M9cpK6UlJ4SeENWLs=
MIME-Version: 1.0
In-Reply-To: <19595.34143.859553.402816@pilspetsen.it.uu.se>
References: <AANLkTimMxQXxC354V=qVOrdUYFSrpJ-RZeKJfQEx0KPN@mail.gmail.com>
	<19595.23873.90306.656565@pilspetsen.it.uu.se>
	<AANLkTinQVQsjxJLpZQiP5V56o7quGPY6G0ZOnvwPAKbx@mail.gmail.com>
	<19595.34143.859553.402816@pilspetsen.it.uu.se>
Date: Sun, 12 Sep 2010 12:33:22 +0530
Message-ID: <AANLkTin8F3=VJ1yoOrNR_hP+52ReYCdL7+LCFBjCEv5D@mail.gmail.com>
Subject: Re: How to determine the information about SATA controller
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  > >
>  >
>  > In my case, BIOS options are enhanced / legacy / disabled. I tried all
>  > but of no use. So I am using enhanced to boot Fedora 13 kernel.
>
> We need to see the complete kernel messages from a failed boot to
> determine the root cause of that missing root device failure.
>
> I suggest hooking up a null-modem serial cable to a second machine
> and run minicom on that one to capture boot messages, but there may
> be other ways to capture boot messages: netconsole? firewire?
>

Netbook is also using SATA Intel controller :
http://userweb.kernel.org/~jaswinder/acer_netbook/config-2636rc3-netbook.txt

I used netbook config and with little bit modification as CPU and
network device is changed, I am able to boot the kernel :

dmesg :
http://userweb.kernel.org/~jaswinder/P4_HT/dmesg_2636_test_netbook.txt

config:
http://userweb.kernel.org/~jaswinder/P4_HT/config-ht-test-netbook.txt

Thanks for your help,
--
Jaswinder Singh.
