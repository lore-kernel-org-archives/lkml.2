Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935001Ab2C3Wyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:54:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49761 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934947Ab2C3VF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] kmsg: Use vmalloc instead of kmalloc when writing
Date: Fri, 30 Mar 2012 21:05:52 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>, viro@zeniv.linux.org.uk,
        davej@redhat.com, linux-kernel@vger.kernel.org
References: <1333127067-2043-1-git-send-email-levinsasha928@gmail.com> <20120330204235.GA883@kroah.com> <alpine.LFD.2.02.1203302247130.2542@ionos>
In-Reply-To: <alpine.LFD.2.02.1203302247130.2542@ionos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203302105.52987.arnd@arndb.de>
X-Provags-ID: V02:K0:Now03PC6g1oYdvxvwnGUuPOkmsIN6TzsiPaJVLv0aHN
 pI8OSF/EasQ67i16GrfF8bXcqGxS+VwlzOt/ZGe3+iu7hStwNq
 AqAzqdNWHzOQuZrygElTNhFVq7TZvlLLA2aGH8/4MUziJP7YNu
 HWIz+rxR90ICwOzpGrZkzoifkTeOiTbXJ1PSwKkpw6ZfoxQvzX
 0xl7p7JLNflGmJ9RfL4oXJSsDChEoCmf0bdOlfPiug3W2+EFL4
 ozVEQ8CYFc7Fz9gSZoEQyohGfXsXvMaXQP9wMK1agE2DJ5u2Va
 fwlUBNoxh25rO45msgpwOJPA5iJzHPIhGVOs1O+h/RsrtHD8xA
 Ps+VvdL7kVk1gBWZPFqw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 March 2012, Thomas Gleixner wrote:
> I think so. This is an interface to inject stuff into dmesg. Limiting
> that to a reasonable size makes sense. We can probably limit it to
> something small like 1024, but I don't know about the "ideas" of those
> folks who think that it's a great idea to do it at all.

I guess a page would be a reasonable size, similar to what we do for
sysfs. 

	Arnd
