Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab1BWRkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:40:12 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64979 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab1BWRkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:40:10 -0500
Message-ID: <4D654626.40901@ru.mvista.com>
Date: Wed, 23 Feb 2011 20:38:46 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB fixes for .38
References: <20110222232703.GA18987@kroah.com>
In-Reply-To: <20110222232703.GA18987@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 23-02-2011 2:27, Greg KH wrote:

> Here are some USB fixes for your .38 tree.

> Nothing major, new device ids and bugfixes.  The USB 3.0 fix was
> applied, and then reverted at the request of Sarah, as she will be
> submitting a better fix later on.

> Another round of tiny musb fixes, and other driver fixes and device ids.

> Please pull from:
> 	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/ usb-linus

> All of these patches have been in the linux-next and mm trees for a
> while.

> The full patches will be sent to the linux-usb mailing list, if anyone
> wants to see them.

> thanks,

> greg k-h

> ------------

>   drivers/usb/core/quirks.c     |    8 ++++++++
>   drivers/usb/musb/musb_core.h  |   17 +++++++++--------
>   drivers/usb/musb/omap2430.c   |    1 +
>   drivers/usb/serial/sierra.c   |    3 +++
>   drivers/usb/serial/usb_wwan.c |   15 +++++++++------
>   drivers/usb/serial/visor.c    |   12 ++++++++++++
>   6 files changed, 42 insertions(+), 14 deletions(-)

> ---------------

> Alan Stern (1):
>        USB: add quirks entry for Keytouch QWERTY Panel

> Felipe Balbi (1):
>        usb: musb: fix build breakage

> Greg Kroah-Hartman (1):
>        Revert "USB: Reset USB 3.0 devices on (re)discovery"

> Jiri Slaby (1):
>        USB: serial/usb_wwan, fix tty NULL dereference

> Johan Hovold (2):
>        usb: musb: omap2430: fix kernel panic on reboot
>        USB: musb: omap2430: fix kernel panic on reboot

    It's the same patch repeated twice. I wonder how it was possible without 
an intevening revert... :-O

WBR, Sergei
