Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab1JUDwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 23:52:13 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38909 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab1JUDwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 23:52:11 -0400
Message-ID: <4EA0EC73.6080005@lwfinger.net>
Date: Thu, 20 Oct 2011 22:52:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Thor Malmjursson <lightningstrike35@live.nl>
CC: ziv_huang@realtek.com, georgia@realtek.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Module rtl8192cu (Upstream kernel bug)
References: <SNT114-W5A13731399C34DE1C30D6A4EB0@phx.gbl>
In-Reply-To: <SNT114-W5A13731399C34DE1C30D6A4EB0@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2011 03:19 PM, Thor Malmjursson wrote:
> Hi. My name is Thor Malmjursson, I'm on the Kubuntu 11.10 OS, and I've
> discovered a bug with a kernel driver module which may need some attention. The
> main details of the bug are here:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/878504
>
> The issue is with the rtl8192cu kernel module, released in the 3.0 series of
> kernels, which we only got for the first time with our distro upgrade about 6
> days ago. I have a USB WiFi adapter which should work with that module, and it
> actually associates with it when I plug it into the PC - the problem is, the
> device is immediately locking open and refusing to scan, either automatically or
> manually.
>
> It's a wireless adapter made by Texet, with the USBID 0BDA:8176
>
> The only way I've been able to get the device to function is through
> ndiswrapper, but native support would be much better.
>
> As all the information you would need (i assume) is present on the bug report I
> listed above, I will leave this with you.
>
> I trust you will be able to help me with this.

I tried to post on the Ubuntu bugzilla, but the response was really slow and I 
gave up there.

The dmesg output you posted there involved using ndiswrapper, thus I did not see 
if the device was able to load the firmware. The specific file for that device 
is /lib/firmware/rtlwifi/rtl8192cufw.bin. It is part of a kernel firmware 
package. I do not know what Ubuntu calls it.

Larry

