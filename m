Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab0CaDH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 23:07:59 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56943 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab0CaDH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 23:07:58 -0400
Message-ID: <4BB2BC7D.7090904@canonical.com>
Date: Wed, 31 Mar 2010 11:07:41 +0800
From: Bryan Wu <bryan.wu@canonical.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: amit.kucheria@canonical.com, netdev@vger.kernel.org,
       s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
       kernel-team@lists.ubuntu.com, gerg@uclinux.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] netdev/fec.c: add phylib supporting to enable carrier
 detection
References: <1269597052-10104-1-git-send-email-bryan.wu@canonical.com> <20100327125703.GB5880@pengutronix.de> <4BB06769.7040708@canonical.com> <20100331030602.GD3520@pengutronix.de>
In-Reply-To: <20100331030602.GD3520@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram Sang wrote:
> On Mon, Mar 29, 2010 at 04:40:09PM +0800, Bryan Wu wrote:
>   
>> On 03/27/2010 08:57 PM, Wolfram Sang wrote:
>>     
>>> On Fri, Mar 26, 2010 at 05:50:52PM +0800, Bryan Wu wrote:
>>>       
>>>> BugLink: http://bugs.launchpad.net/bugs/457878
>>>>
>>>>   - removed old MII phy control code
>>>>   - add phylib supporting
>>>>   - add ethtool interface to make user space NetworkManager works
>>>>
>>>> Tested on Freescale i.MX51 Babbage board.
>>>>         
>>> Sadly, I have problems here booting a custom board:
>>>
>>>       
>> Firstly, I working on our Ubuntu Lucid 2.6.31 based kernel. This patch works
>> fine on our system. Then I forward port it to 2.6.34-rc2 Linus mainline kernel.
>> It also works fine on my hardware.
>>     
>
> Hmm, can I provide some more information to get an idea what is happening here?
>
>   
No problem, man. I do love to help this.

-Bryan
