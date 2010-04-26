Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab0DZOJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 10:09:08 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:54298 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab0DZOJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 10:09:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=b4dqDBzoWXn3b28bLALe0Z7bfhsypvwguBrsHke1/EFmPClmHgpFBagcrBfRm8p1eJ
         OG+HzhgFSyxdHs6n3djiP8781ZgBgrSGb63JJ8ZSYstm1lhxqkLLY7xCoP4JBzMut87U
         /UamzE5uLss7r+cvJcqxJyC6voRPE8Wmp75NY=
MIME-Version: 1.0
In-Reply-To: <201004261550.49512.arnd@arndb.de>
References: <1272191830-23675-1-git-send-email-abogani@texware.it>
	 <201004261515.56750.arnd@arndb.de>
	 <w2t63a49ef41004260630o31d81ff0qd98cfdace7e73ce0@mail.gmail.com>
	 <201004261550.49512.arnd@arndb.de>
Date: Mon, 26 Apr 2010 16:09:03 +0200
X-Google-Sender-Auth: 6886bd409263ec1a
Message-ID: <p2m63a49ef41004260709o5d331376hd806b27e63bc9abc@mail.gmail.com>
Subject: Re: [PATCH] USB: sisusbvga: Remove the BKL from open
From: Alessio Igor Bogani <abogani@texware.it>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Oliver Neukum <oneukum@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       Thomas Winischhofer <thomas@winischhofer.net>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Pete Zaitcev <zaitcev@redhat.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Fr??d??ric Weisbecker" <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Bergmann,

2010/4/26 Arnd Bergmann <arnd@arndb.de>:
> On Monday 26 April 2010, Alessio Igor Bogani wrote:
>> It is what effectively I'm trying to do!
>>
>> The first part of this work is already present in USB subsystem
>> maintainer tree (aka greg) at:
>> http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/usb/usb-sisusbvga-remove-the-bkl-from-ioctl.patch
>>
>
> Ok, looks good then. I just wouldn't bother splitting the work into two patches if you
> want to do this for more drivers.

You are right. Simply I made the above-mentioned patch when BKL
pushdown not yet reach _open function. :-)

Ciao,
Alessio
