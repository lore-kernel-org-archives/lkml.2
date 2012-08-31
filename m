Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab2HaLsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 07:48:21 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:36173 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab2HaLsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 07:48:20 -0400
Message-ID: <5040A481.7020403@parrot.com>
Date: Fri, 31 Aug 2012 13:48:17 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>, "gregkh@suse.de" <gregkh@suse.de>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthieu CASTET <castet.matthieu@free.fr>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] hvc_dcc : add support to armv4 and armv5 core
References: <1346404916-27616-1-git-send-email-castet.matthieu@free.fr>	<20120831110444.25d9b9fe@pyramind.ukuu.org.uk>	<504091F0.1090703@parrot.com>	<20120831103351.GE18957@n2100.arm.linux.org.uk> <20120831115939.23fd4a08@pyramind.ukuu.org.uk>
In-Reply-To: <20120831115939.23fd4a08@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox a écrit :
> On Fri, 31 Aug 2012 11:33:51 +0100
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
>> On Fri, Aug 31, 2012 at 12:29:04PM +0200, Matthieu CASTET wrote:
>>> Alan Cox a écrit :
>>>> On Fri, 31 Aug 2012 11:21:56 +0200
>>>> Matthieu CASTET <castet.matthieu@free.fr> wrote:
>>>>
>>>>> Signed-off-by: Matthieu Castet <matthieu.castet@parrot.com>
>>>>> ---
>>>>>  drivers/tty/hvc/hvc_dcc.c |   34 ++++++++++++++++++++++++++++++++++
>>>>>  1 file changed, 34 insertions(+)
>>>> This is a step in the wrong direction. This should all be runtime handled
>>>>
>>>> NAK.
>>>>
>>> AFAIK you can't build a arm kernel that support arm6/armv7 and armv5.
>>> And I am not sure it will be possible one day.
>> There are no plans to ever make it possible; there are too many significant
>> differences between ARMv4, v5 architectures and ARMv6,v7 architectures
>> to warrant making this runtime selectable.
> 
> Then bury this crap in platform files please not in the drivers/tty layer
> code. Make it a platform driver provided callback or something.
> 
I posted a new v2 patch that make the selection dynamic.


Matthieu
