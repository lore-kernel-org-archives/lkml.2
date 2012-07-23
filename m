Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab2GWPFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 11:05:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42953 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab2GWPFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 11:05:53 -0400
MIME-Version: 1.0
In-Reply-To: <500D659E.5090207@gmail.com>
References: <Pine.LNX.4.44L0.1207231044380.1633-100000@iolanthe.rowland.org>
	<500D659E.5090207@gmail.com>
Date: Mon, 23 Jul 2012 20:35:53 +0530
Message-ID: <CAP2rAF8Kk7CfDeg2dAqK_oZdUzuWDm1+Rd=uoKS5GVw0ssDpfw@mail.gmail.com>
Subject: Re: Kernel Oops while disconnecting USB peripheral (always)
From: Sarbojit Ganguly <unixman.linuxboy@gmail.com>
To: Daniel Mack <zonque@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 July 2012 20:24, Daniel Mack <zonque@gmail.com> wrote:
> On 23.07.2012 16:47, Alan Stern wrote:
>> On Mon, 23 Jul 2012, Sarbojit Ganguly wrote:
>>> That is why I provided two stacks,
>>>
>>> 1st one is when I tried to remove the USB hub (which connects a webcam
>>> + microphone)
>>> 2nd one is when I tried to remove an USB powered external HDD.
>>>
>>> Just to make sure whether the problem is with USB sound or the USB subsystem.
>>
>> Do you stop all the programs that are using the USB devices before
>> unplugging the hub?  Do you unmount the USB HDD first?
>>
>> The first crash shows a problem in the snd-usb-audio driver.
>>
>> The second crash shows a problem in the VFS layer or in ext3, not in
>> the USB stack.
>
> I dare to doubt there are two severe bugs of that kind that are 100%
> reproducible. I haven't had a  hotplug crash in any of the two drivers
> for a long time, and I use both of them extensively.
>
> I rather assume there's something else failing, probably some host
> controller issue that corrupts mempory? Can anyone else reproduce this
> maybe?
>
>
>
> Daniel
>

I will be happy to provide my .config if that is required. I think
that might help in narrowing down the bug

-- 
Regards,
Sarbojit
