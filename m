Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab0CaLJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 07:09:00 -0400
Received: from lucidpixels.com ([75.144.35.66]:37298 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756895Ab0CaLI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 07:08:59 -0400
Date: Wed, 31 Mar 2010 07:08:58 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Tiago Vignatti <vignatti@freedesktop.org>
cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       xorg@lists.freedesktop.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.33: Xorg+khubd lockup (D-state) BUG / ioctl EVIOCGNAME
 failed: Inappropriate ioctl for device / PreInit returned NULL
In-Reply-To: <4BB286F5.9060706@freedesktop.org>
Message-ID: <alpine.DEB.2.00.1003310708330.8278@p34.internal.lan>
References: <alpine.DEB.2.00.1003250800200.13307@p34.internal.lan> <alpine.DEB.2.00.1003250833040.13307@p34.internal.lan> <alpine.DEB.2.00.1003250935030.21591@p34.internal.lan> <4BB286F5.9060706@freedesktop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 31 Mar 2010, Tiago Vignatti wrote:

> Justin Piszcz wrote:
>> 
>> 
>> On Thu, 25 Mar 2010, Justin Piszcz wrote:
>> 
>>> 
>>> 
>>> On Thu, 25 Mar 2010, Justin Piszcz wrote:
>>> 
>>> The same problem has been reported by another person, he says his entire 
>>> system freezes, which, it appears to do unless you can SSH into the box:
>>> http://www.openoffice.org/issues/show_bug.cgi?id=76797
>>> 
>>> Look at his lspci listing.
>>> james@dv6105us:~$ lspci
>>> 00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
>>> 00:00.1 RAM memory: nVidia Corporation C51 Memory Controller 0 (rev a2)
>>> 00:00.2 RAM memory: nVidia Corporation C51 Memory Controller 1 (rev a2)
>>> 
>>> Here is mine:
>>> $ lspci
>>> 00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
>>> 00:00.1 RAM memory: nVidia Corporation C51 Memory Controller 0 (rev a2)
>>> 00:00.2 RAM memory: nVidia Corporation C51 Memory Controller 1 (rev a2)
>>> 00:00.3 RAM memory: nVidia Corporation C51 Memory Controller 5 (rev a2)
>>> 
>>> Looks like the bug may be in the USB subsystem for this chipset.
>>> 
>>> Justin.
>>> 
>>> 
>> 
>> Hi,
>> 
>> And there it goes again *LOCK*
>> root      2190  0.5  1.5  37832 31424 tty7     Ds+  09:00   0:12 /usr/bin/X 
>> :0 vt7 -nolisten tcp -auth /var/lib/xdm/authdir/authfiles/A:0-N5V00o
>
> running X server with -nosilk helps something?

Hi,

After the BIOS update and request from Alan, if it *STILL* persists, I can try
this, thanks.

# grep -i silken Xorg.0.log*
Xorg.0.log:(==) NV(0): Silken mouse enabled
Xorg.0.log.old:(==) NV(0): Silken mouse enabled

Justin.

