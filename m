Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab1AGV25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 16:28:57 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47623 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab1AGV2z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 16:28:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=kw7HTxYOTLfvQlvfdDwW86QbY50JVB4U51C/C/kgdvogaE7EIoXp+kEYDhS8QrwEB9
         1FDIdhtR++rUAzRWir/n87cXgapYBXJaLw5kkAnQy2fwvI2aqtDqtlggOkVBCrnFjXfd
         GLCwfZuQJ39kzzv/enRJx2Q2Jh0pe8W0ZoJYU=
Date: Fri, 7 Jan 2011 22:28:45 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
Message-ID: <20110107222845.1cd02e26@varda>
In-Reply-To: <AANLkTikwrHoOY4wvUp1qn-OT=EjZesSNR29US1ERc0o2@mail.gmail.com>
References: <20110106.122003.233698077.davem@davemloft.net>
	<AANLkTi=7=_FyVsjA3vKEpg8RwfC=m-8QGfqa6ctxQday@mail.gmail.com>
	<20110107190656.GQ3702@decadent.org.uk>
	<AANLkTikwrHoOY4wvUp1qn-OT=EjZesSNR29US1ERc0o2@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Fri, 7 Jan 2011 11:49:37 -0800
Linus Torvalds <torvalds@linux-foundation.org> escribió:


> 
> [ Apart from the annoyance of also having to manually copying the
> firmware files: why the heck doesn't that firmware tree even have a
> "make firmware-install" makefile or something? The kernel has a "make
> firmware-install" thing, why doesn't the firmware tree itself have
> that? Gaah, this is almost as idiotic as trying to install a
> self-built kernel under Ubuntu ]
 
 Maybe i am just making myself a fool but i'll bite:
 this has allways worked for me

 make && sudo make install && sudo make modules_install
 sudo mkintramfs -o /boot/initrd-$kernel_version  $kernel_version
 sudo update-grub
 [ reboot the machine ]


> 
>                         Linus
