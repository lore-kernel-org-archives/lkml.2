Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab0HWKJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 06:09:04 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52490 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab0HWKJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 06:09:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=J7MRdz4q0ItmszrVbBsUbKoDhHgztBZBWlX/NO9/aA6EmKkiDGbFXMP1pYHAemKRnU
         OnNzCb/ZXWcFeXmjdQ8nUFCD9AseCgtOx2GfqlrCN28n6Z25tEYFfxjPugaLc6uViZjI
         /zB1v1AsgTPNijgOLXhtyR8mlFz1tQOj5xVq0=
MIME-Version: 1.0
In-Reply-To: <AANLkTinAqJdEPpTFsmY8rWYqy84qGsWVbL9VphOur+PT@mail.gmail.com>
References: <AANLkTinAqJdEPpTFsmY8rWYqy84qGsWVbL9VphOur+PT@mail.gmail.com>
Date: Mon, 23 Aug 2010 13:09:01 +0300
Message-ID: <AANLkTim_Mu8PiOM+kD3y3Zejr+u=Fqutk9d7SafDEsdH@mail.gmail.com>
Subject: Re: Ubuntu 10.10 Kernel compile error
From: Anca Emanuel <anca.emanuel@gmail.com>
To: linux-kernel@vger.kernel.org, apw@canonical.com, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC to apw@canonical.com, if there are orher people, let me know.

On Sun, Aug 22, 2010 at 3:24 PM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
> Steps to reproduce on Ubuntu 10.10
>
> 1. sudo apt-get install git-core kernel-package fakeroot
> build-essential ncurses-dev
> 2. git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> 3. cd linux-2.6
> 4. cp /boot/config-`uname -r` .config
> 5. yes '' | make oldconfig
> 6. make nconfig
> and select to not make the staging drivers
> 7. make-kpkg clean
> 8. CONCURRENCY_LEVEL=`getconf _NPROCESSORS_ONLN` fakeroot make-kpkg
> --initrd --append-to-version=-c kernel_image kernel_headers
>
> result:
>
> dpkg-gencontrol: error: package linux-image-2.6.36-rc1-c+ not in control info
> make[2]: *** [debian/stamp/binary/linux-image-2.6.36-rc1-c+] Error 255
> make[2]: Leaving directory `/home/username/linux-2.6'
> make[1]: *** [debian/stamp/binary/pre-linux-image-2.6.36-rc1-c+] Error 2
> make[1]: Leaving directory `/home/username/linux-2.6'
> make: *** [kernel_image] Error 2
>

yes you have some patches, why don't you upstream them ?
Gregh, what is so hard to publish some compiler paches ? only becouse
you are suse ?
It is rc2 time an you did not publish, or asked Linus to pull the
fixes in your tree
