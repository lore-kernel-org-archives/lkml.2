Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760Ab0EXWEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 18:04:42 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:46546 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab0EXWEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 18:04:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JT95lv+5KCMX3AFrMO3v81mjxAZFEgBe5IHRf9pJcAagzvDpg/N5k6CVv55vT22lJF
         R3pS0jCnwoZv4flIcZojikCszcrdRpjZPs0RW3fe/b48wJ9g5lgoJIYQNglMS48Eg/MH
         MCyKFpUr+6BX81cU3uhLDYbJ3k84IPBfgausc=
Message-ID: <4BFAF806.6060200@gmail.com>
Date: Mon, 24 May 2010 15:04:54 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Chriss Kalogeropoulos <iz.iznogood@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Ubuntu boot time on imac
References: <1274736781.4278.7.camel@chriss-buntu>
In-Reply-To: <1274736781.4278.7.camel@chriss-buntu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2010 02:33 PM, Chriss Kalogeropoulos wrote:
> Hi all,
>
> I have also posted this on ubuntu forums hoping for an answer but i
> believe this is the right place
>
> i have a 24'' imac core duo 2 (2007 model), 4GB ram, nvidia 7600
>
> I recently installed ubuntu lucid 64 bit and everything worked
> perfectly. The boot times where 14.5 secs on a clean installation from
> grub to full desktop. I even enabled the xorg-edgers repo and nouveau
> with 3d was working almost perfectly. The boot time was around 20-23
> secs with compiz enabled and 2.6.34-2 kernel installed from xorg-edgers.
>
> What i tried next was to manually compile the 2.6.34 kernel and
> statically link all drivers, to improve performance and boot time a bit.
> This also worked fine and the system works ok.
>
> However, i did not see any improvements during boot (around 20 secs) and
> there is a huge gap of 10 second from the time the kernel initializes
> usb until udev is started. The logs are completely empty.
>
> The build has only the necessary drivers. Can someone explain what is
> happening and if there is a way to improve on that ?
> Are there any kernel options or tools i can use to get more info on what
> is happening during this period ?
>
> I attach my kernel config, a dmesg log and the boot chart png
>
> Please cc me since i am not on the list
>
> Thanks in advance
>
>
>    

had the something similar(15 sec pause during boot)
ended up being(for me at-least) in /lib/udev/write_net_rules,
removing this get a smooth boot, but there were other caseses
that this was not the case(instead was something in /etc/udev/*)

to debug add a --debug when starting udev i.g.
udev --debug etc...(should show info on screen)

Justin P. Mattock
