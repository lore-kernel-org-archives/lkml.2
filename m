Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab0G3Ex0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 00:53:26 -0400
Received: from adelie.canonical.com ([91.189.90.139]:40704 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab0G3ExY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 00:53:24 -0400
Message-ID: <4C525AAF.6020102@canonical.com>
Date: Fri, 30 Jul 2010 12:53:03 +0800
From: Bryan Wu <bryan.wu@canonical.com>
Reply-To: bryan.wu@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>, felipe.balbi@nokia.com
CC: linux-usb@vger.kernel.org, kernel-team@lists.ubuntu.com,
        linux-kernel@vger.kernel.org, ricardo.salveti@canonical.com,
        david-b@pacbell.net
Subject: Re: [PATCH] musb: move usb_add_hcd to the core init code from gadget
 code (v2)
References: <1279895783-7313-1-git-send-email-bryan.wu@canonical.com> <4C49B529.8080408@ru.mvista.com>
In-Reply-To: <4C49B529.8080408@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2010 11:28 PM, Sergei Shtylyov wrote:
> Hello.
> 
> Bryan Wu wrote:
> 
>> BugLink: http://bugs.launchpad.net/bugs/608312
> 
>> v2:
>> fix the building error on latest 2.6.35-rc kernel, since v1 was
>> generated in
>> 2.6.33 kernel.
> 
>    The remarks about patch changes should follow the --- tear line.
> 

Thanks Sergei, I will take care of it in the future.

Any other comments about this patch?

Felipe, could you please take a look? or need I ping you in the Facebook, -:))

-Bryan

>> v1:
>> usb_add_hcd was only called when we insmod the gadget class module or
>> built-in
>> that gadget class driver. If musb is configured as OTG controller, we
>> need to
>> insmod or built-in gadget class driver to make our Host mode fucntion
>> works.
> 
>> In our Ubuntu system, normally we compiled all the gadget class
>> drivers as
>> modules. Then users can insmod the gadget modules as they want. But
>> without the
>> gadget class driver running, we needs host function to support common USB
>> devices.
> 
>> This patch fix this issue and tested on omap3 beagle board and Gumstix
>> board.
> 
>> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> 
> WBR, Sergei
