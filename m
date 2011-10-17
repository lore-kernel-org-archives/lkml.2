Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab1JQCQu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 22:16:50 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:32873 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab1JQCQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 22:16:49 -0400
Message-ID: <4E9B9018.1000002@lwfinger.net>
Date: Sun, 16 Oct 2011 21:16:56 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: werner <w.landgraf@ru.ru>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        dave.taht@gmail.com, rientjes@google.com, arend@broadcom.com,
        toralf.foerster@gmx.de, wey-yi.w.guy@intel.com, ilw@linux.intel.com,
        larry.finger@gmail.com
Subject: Re: 3.1-rc9 wifi problem
References: <web-626905859@zbackend1.aha.ru> <4E9A4496.1000906@lwfinger.net> <web-627302724@zbackend1.aha.ru>
In-Reply-To: <web-627302724@zbackend1.aha.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2011 08:33 PM, werner wrote:
> I have to wait until the friend with the laptop comes back, perhaps this week.
> Then I can look what wireless card is in it.
>
> However, now I remember me: that laptop worked only good since 2.6.39 with the
> new kernel-embedded modules. Before, it didn't work normally, i.e. on booting
> the wireless almost never didn't switch on; only ocasionally .
>
>
> And, beside of kernel 2.6.39, and the normal wifi software, I still had him to
> install a file iwlwifi-1000-3.ucode or .5 ucode (i'm not sure, the number can
> also be 5000), and I had the problem to search long time for that file because
> one find only .2 or .4 in internet but what don't work at that wifi card. You
> could improve the kernel-module so that everything is included so that one don't
> need to search such files.

That will not happen. In fact, the trend is from having firmware be a part of 
the driver to having it be external.

I don't know what distro you use, but mine (openSUSE) maintains a package called 
kernel-firmware that contains all the redistributable firmware that is available 
from tne linux-firmware git tree. If that package is installed, then you do not 
have to search for firmware in most cases. If your distro does not have such a 
package, then complain or find another distro.

> Then, with this kernel and that file however, it worked without any problem.
>
> I hope from these informations you can find out what wifi card or what driver is
> in the laptop.

We can tell that you have an Intel card, but not much more.

Larry

