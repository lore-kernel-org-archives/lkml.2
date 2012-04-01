Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212Ab2DAKCx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 06:02:53 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61444 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2DAKCv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 06:02:51 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20120331011432.GG7274@titan.lakedaemon.net>
References: <1332804040.5294.2.camel@phoenix> <20120331011432.GG7274@titan.lakedaemon.net>
From: Axel Lin <axel.lin@gmail.com>
Date: Sun, 1 Apr 2012 18:02:30 +0800
Message-ID: <CAF+7xWkuZ6q1TbWpdvwK57wGBwd_naVZsvtj0UackWWFcam7qw@mail.gmail.com>
Subject: Re: [PATCH RFT v3] watchdog: Convert orion_wdt driver to watchdog core
To: Jason Cooper <jason@lakedaemon.net>
Cc: linux-kernel@vger.kernel.org,
        Sylver Bruneau <sylver.bruneau@googlemail.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/31 Jason Cooper <jason@lakedaemon.net>:
> On Tue, Mar 27, 2012 at 07:20:40AM +0800, Axel Lin wrote:
>> Convert orion_wdt driver to use watchdog framework API.
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>> ---
>> Hi Jason, Andrew,
>> I don't have this hardware handy.
>> I'd appreciate if you can review and test this patch.
>
> Axel,
>
> Sorry for the delay, been a busy week.  I'm getting the following error:
>
> drivers/watchdog/orion_wdt.c:133:2: error: unknown field 'get_timeleft'
> specified in initializer
> drivers/watchdog/orion_wdt.c:133:2: warning: initialization from
> incompatible pointer type
>
> What tag did you base this off of?  Are there any dependencies not in
> mainline?
I generate the patch base on linux-next tree.
I just checked Linus' tree and this patch is appliable to Linus' tree.
The required commit[1] is alread merged to Linus' tree now.
Can you check it again?
Thanks.

[1] http://www.linux-watchdog.org/cgi-bin/gitweb.cgi?p=linux-watchdog.git;a=commitdiff;h=fd7b673c92731fc6c0b1e999adfd87b6762ee797
