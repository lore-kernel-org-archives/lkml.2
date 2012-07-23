Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab2GWOzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 10:55:12 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56418 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab2GWOzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 10:55:06 -0400
Message-ID: <500D659E.5090207@gmail.com>
Date: Mon, 23 Jul 2012 16:54:22 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Sarbojit Ganguly <unixman.linuxboy@gmail.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: Kernel Oops while disconnecting USB peripheral (always)
References: <Pine.LNX.4.44L0.1207231044380.1633-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1207231044380.1633-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.07.2012 16:47, Alan Stern wrote:
> On Mon, 23 Jul 2012, Sarbojit Ganguly wrote:
>> That is why I provided two stacks,
>>
>> 1st one is when I tried to remove the USB hub (which connects a webcam
>> + microphone)
>> 2nd one is when I tried to remove an USB powered external HDD.
>>
>> Just to make sure whether the problem is with USB sound or the USB subsystem.
> 
> Do you stop all the programs that are using the USB devices before 
> unplugging the hub?  Do you unmount the USB HDD first?
> 
> The first crash shows a problem in the snd-usb-audio driver.
> 
> The second crash shows a problem in the VFS layer or in ext3, not in 
> the USB stack.

I dare to doubt there are two severe bugs of that kind that are 100%
reproducible. I haven't had a  hotplug crash in any of the two drivers
for a long time, and I use both of them extensively.

I rather assume there's something else failing, probably some host
controller issue that corrupts mempory? Can anyone else reproduce this
maybe?



Daniel

