Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab0DZNai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 09:30:38 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:34941 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab0DZNag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 09:30:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=FniumzMb43nknuuwmrWkkT7sI61NoaDtdV+6h7eyQCursEiNcQY0fGN2z4qbQDMLOx
         mRhDVtuJSRZTra3Mb5+7GSoBOmDqRAN2ckRFTIv2LGpbegjdrE6HHUWBmv0dktb2j4RM
         2LPp+NoBtPSAhKwUqhAtsvmLXTkrh3PUVk8jU=
MIME-Version: 1.0
In-Reply-To: <201004261515.56750.arnd@arndb.de>
References: <1272191830-23675-1-git-send-email-abogani@texware.it>
	 <201004261406.50107.oneukum@suse.de>
	 <h2i63a49ef41004260530x49db3ddczf43423aa49f3b9e1@mail.gmail.com>
	 <201004261515.56750.arnd@arndb.de>
Date: Mon, 26 Apr 2010 15:30:34 +0200
X-Google-Sender-Auth: 218bbc6ee2df9b7c
Message-ID: <w2t63a49ef41004260630o31d81ff0qd98cfdace7e73ce0@mail.gmail.com>
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
>> >> BKL is not needed here because necessary locking is already provided
>> >> by mutex sisusb->lock.
[...]
> What about the BKL in the sisusb_ioctl()? It seems to follow the
> same logic, so I would think that you can simply remove the BKL
> from the module entirely, rather than only half of it.

It is what effectively I'm trying to do!

The first part of this work is already present in USB subsystem
maintainer tree (aka greg) at:
http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/usb/usb-sisusbvga-remove-the-bkl-from-ioctl.patch

Ciao,
Alessio
