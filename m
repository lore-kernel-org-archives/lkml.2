Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563Ab0C3Xyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:54:31 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:47841 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393Ab0C3XTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rYffwETZVAVSt2DMSvWeC9EgC05iXBa89S3+wTMZ8fSJ4/wAPk0OSisu4/gXWWpo/t
         G7RXSyT1c1tgI0IhtnmQGD17T2YVouPyGp5+rY7aoSueWwrKlvuY4ozxp8neWVMRf7yz
         17iI6d0zndQaWoKqivlE50on+rXimqcfvP9xw=
Message-ID: <4BB286F5.9060706@freedesktop.org>
Date: Wed, 31 Mar 2010 02:19:17 +0300
From: Tiago Vignatti <vignatti@freedesktop.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       xorg@lists.freedesktop.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.33: Xorg+khubd lockup (D-state) BUG / ioctl EVIOCGNAME failed:
 Inappropriate ioctl for device / PreInit returned NULL
References: <alpine.DEB.2.00.1003250800200.13307@p34.internal.lan>	<alpine.DEB.2.00.1003250833040.13307@p34.internal.lan> <alpine.DEB.2.00.1003250935030.21591@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.1003250935030.21591@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> 
> 
> On Thu, 25 Mar 2010, Justin Piszcz wrote:
> 
>>
>>
>> On Thu, 25 Mar 2010, Justin Piszcz wrote:
>>
>> The same problem has been reported by another person, he says his 
>> entire system freezes, which, it appears to do unless you can SSH into 
>> the box:
>> http://www.openoffice.org/issues/show_bug.cgi?id=76797
>>
>> Look at his lspci listing.
>> james@dv6105us:~$ lspci
>> 00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
>> 00:00.1 RAM memory: nVidia Corporation C51 Memory Controller 0 (rev a2)
>> 00:00.2 RAM memory: nVidia Corporation C51 Memory Controller 1 (rev a2)
>>
>> Here is mine:
>> $ lspci
>> 00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
>> 00:00.1 RAM memory: nVidia Corporation C51 Memory Controller 0 (rev a2)
>> 00:00.2 RAM memory: nVidia Corporation C51 Memory Controller 1 (rev a2)
>> 00:00.3 RAM memory: nVidia Corporation C51 Memory Controller 5 (rev a2)
>>
>> Looks like the bug may be in the USB subsystem for this chipset.
>>
>> Justin.
>>
>>
> 
> Hi,
> 
> And there it goes again *LOCK*
> root      2190  0.5  1.5  37832 31424 tty7     Ds+  09:00   0:12 
> /usr/bin/X :0 vt7 -nolisten tcp -auth 
> /var/lib/xdm/authdir/authfiles/A:0-N5V00o

running X server with -nosilk helps something?


           Tiago
