Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab1JYLXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 07:23:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62569 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab1JYLXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 07:23:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: fix build error in include/asm-generic/gpio.h
Date: Tue, 25 Oct 2011 13:23:44 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Hamo <hamo.by@gmail.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <CAO_0yfOa7B4tB1nJg8c_5a612KjNmPh_aMvS=wHhfU_maAvZAg@mail.gmail.com> <201110211339.59280.arnd@arndb.de> <CACxGe6sFrJh+Y5CJVMTPiWH3m=j+J_YUzLP=MiaBbsvDkeA_Jg@mail.gmail.com>
In-Reply-To: <CACxGe6sFrJh+Y5CJVMTPiWH3m=j+J_YUzLP=MiaBbsvDkeA_Jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110251323.44313.arnd@arndb.de>
X-Provags-ID: V02:K0:ulVdNUB/mccnyGJkNmIH8RUhkUR5n2j21mSv33bTfbE
 vDKE1W5K/lacAQGGGxTF38agDBm0QUbCsEdwnNl42LkWh5xkCM
 h9NAkRUI8PXpsIUFN5wlmTd5iMMv6+/EUJFE3Wns3ZAxXh9ixD
 stBAuO9l6uTZUklydy2+/2XlL8iMlAx35+m9x93Q5KKmBFf4qD
 boL1kCLLQ8pUt2fIVfG/Yq9nm8kgMkw4/U3Fcdq3ExV1aYYDW6
 Ry7Vms7jE7VLK3xZa34fen8/hh4qnvhuTV+reP9oEP7F1gnAjQ
 7/H86CfeYIVjSJ1C9CIhSvA6AzdclSUlJJ7aBO/9NpnYfdmMp1
 6Y3kXGzHUVbkIPf6ybLY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 October 2011, Grant Likely wrote:
> by: Arnd Bergmann <arnd@arndb.de>
> >
> > Grant, can you put that into the gpio tree?
> 
> I can.
> 
> Hamo, next time make sure you cc: the relevant subsystem maintainer
> (in this case, me) when submitting patches.  You can find the
> maintainer by using ./scripts/get_maintainer.pl, or by looking at the
> MAINTAINERS file.  It is more work for me when I don't receive the
> patch directly in my inbox.

I would assume that this is what Hamo did:

$ ./scripts/get_maintainer.pl -f include/asm-generic/gpio.h 
Arnd Bergmann <arnd@arndb.de> (maintainer:GENERIC INCLUDE/A...)
linux-arch@vger.kernel.org (open list:GENERIC INCLUDE/A...)
linux-kernel@vger.kernel.org (open list)

	Arnd
