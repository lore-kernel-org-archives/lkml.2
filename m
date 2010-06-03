Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933799Ab0FCDhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 23:37:52 -0400
Received: from static.206.87.46.78.clients.your-server.de ([78.46.87.206]:33447
	"EHLO Kolkata.infoservices.in" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933730Ab0FCDhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 23:37:51 -0400
X-Greylist: delayed 565 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jun 2010 23:37:51 EDT
Message-ID: <4C072155.3060405@infoservices.in>
Date: Thu, 03 Jun 2010 08:58:21 +0530
From: "J. Bakshi" <joydeep@infoservices.in>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-3.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: How to tweak 2.6.34 kernel for acer 5740 laptop ?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linux kernel Developers ,

My greetings to all of you.

I have compiled kernel a no. of times with the help of some online
tutorials, but this time I need some special information and hope you
kindly enlighten me. I have bought an acer 5740 laptop which equipped
with interl-i5, intel 3440 chipset, intel HD graphics. I tried to
install debian squeeze through net-intaller CD but the big problem was
ethernet which required tg3 driver. Hence I download debian's first two
DVD image and add those to insall kernel compilation tools. Now I have a
2.6.34 kernel compiled with tg3 driver and I get my internet back. So
far so good.

But I have still found some problems, I can't control the LCD brightness
and I have found from dmesg that

``````````````````
acer wmi: can't load, no such device
````````````````````

More over I have compiled the kernel with xframebuffer support and linux
logo ( both 16 bit and 32 bit ). But no logo is appearing during booting
and the *CLI screen is performing very very slow *. My old Desktop CLI
is performing very fast than this high end laptop linux CLI.

with the xserver-xorg ; if I use vesa as driver I can switch to
different virtual console by [ctrl] + [alt] + [F.. keys] ; but with
"intel" driver (xserver-xorg-video-intel), though I get the correct
resolution and color, it hang the box when I try to go to virtual
console. Hardware restart is only solution to get back the system.

I have a impression that I need to tweak the kernel to activate the
features rather than blaming the hardware. But I really don't know where
to look or where to activate the required options which in turn activate
these features. Could any one kindly put me on the right track ?

thanks for your time and please CC to me



-- 
জয়দীপ বক্সী

