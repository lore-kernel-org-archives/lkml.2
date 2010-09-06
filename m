Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab0IFKrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 06:47:22 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56432 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab0IFKrU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 06:47:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DvcsDSzn9fMhTRtXuUSvNgnL20UX18Rlr8DdzHS139rkO5gAVCvMo871Bt78zc2VvG
         mviEhTJX6F3MvnXu2YGEN5OlSDkpSXgH8FS/fQcNfTUtzZtPdeetr6KkOuivfhvD0CK8
         oqttbuwBct3RUSg43WazLwyd4A14EdBeCRz9A=
MIME-Version: 1.0
In-Reply-To: <20100903140041.GA16223@kroah.com>
References: <AANLkTimSsj5eW1Vy3g7S0XCKRcZ0fZ0jQ6_9VpjVMYcj@mail.gmail.com>
	<20100903140041.GA16223@kroah.com>
Date: Mon, 6 Sep 2010 16:17:19 +0530
Message-ID: <AANLkTi=xaTdjrb3ZO5dU+bY_GpaBE4F2-0gFmN=SykD5@mail.gmail.com>
Subject: Re: Crash on reducing the kernel mem.
From: Prabhu Chawandi <prabhu.chavandi@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        kernelnewbies@nl.linux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

  I am specifying the memory as part of command line parameter "mem=".
I know only that what ever amount specify against "mem=" will be a
kernel memory and rest is used for the drivers.

If I have not answered you correctly, please give me a chance to understand...

thanks,
Prabhu

On Fri, Sep 3, 2010 at 7:30 PM, Greg KH <greg@kroah.com> wrote:
> On Fri, Sep 03, 2010 at 12:04:09PM +0530, Prabhu Chawandi wrote:
>> Hi all,
>>
>>  I am using MIPS processor, with 256 MB RAM. currently I am using 128
>> M for drivers and 128 M for Kernel. I tried to allocate more memory
>> for Drivers,
>> surprisingly I got crash when I reduced kernel memory to 110 M. My
>> debugging took me to USB controller, which was not reset in
>> bootloader.
>>
>> I am not having any clue, why it didnt crash with 128 M ? How reducing
>> memory  for kernel bringing it up ?
>
> Perhaps your drivers really needed that much memory.  How are you
> "splitting" memory up between drivers and the kernel when the drivers
> and kernel all share the same memory areas?
>
> good luck,
>
> greg k-h
>
