Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab2G3OaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:30:20 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54927 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab2G3OaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:30:19 -0400
Message-ID: <50169A77.3050402@linaro.org>
Date: Mon, 30 Jul 2012 15:30:15 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 17/18] ARM: ux500: Add all encompassing Sound node to
 DB8500 Device Tree
References: <1343393162-11938-1-git-send-email-lee.jones@linaro.org> <1343393162-11938-18-git-send-email-lee.jones@linaro.org> <20120729205227.GL4384@opensource.wolfsonmicro.com> <50163936.1050901@linaro.org> <20120730134220.GD4468@opensource.wolfsonmicro.com>
In-Reply-To: <20120730134220.GD4468@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/07/12 14:42, Mark Brown wrote:
> On Mon, Jul 30, 2012 at 08:35:18AM +0100, Lee Jones wrote:
>> On 29/07/12 21:52, Mark Brown wrote:
>
>>> ...this is clearly the board-specific setup for the system, showing how
>>> the CPU and CODEC are hooked up.  This should therefore be in the DT for
>>> whatever board this is you're working on.
>
>> I don't think it's board specific. I believe this is the setup on
>> all db8500 platforms. I'm happy to be told I'm wrong here, in which
>> case I can move it to the board specific files.
>
> I think that's more a sign that all the platforms you've seen are just
> cut'n'pasted from the reference design than anything else.  If the thing
> you're describing is on the PCB it's generally board specific...

I'll split it out into the board file(s) if it makes you happy. I'd 
rather just get it in and move on to something more productive. We can 
change it retrospectively if I'm told by someone more knowledgeable that 
it's 100% common across all platforms.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
