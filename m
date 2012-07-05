Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114Ab2GENzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:55:40 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40900 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab2GENzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:55:37 -0400
Message-ID: <4FF59CD5.3030007@linaro.org>
Date: Thu, 05 Jul 2012 14:55:33 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH 3/9] ARM: ux500: Remove AB8500 regulator register initialisation
 information
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org> <1341493572-29735-4-git-send-email-lee.jones@linaro.org> <201207051351.03115.arnd@arndb.de>
In-Reply-To: <201207051351.03115.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/12 14:51, Arnd Bergmann wrote:
> On Thursday 05 July 2012, Lee Jones wrote:
>> There is no need to initialise the AB8500's regulator registers, as
>> most of this work is already carried out by framework features, so
>> we can safely remove all traces from platform code.
>>
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>
> It makes sense, but this patch is basically a revert of dfa3a824d
> "mach-ux500: provide ab8500 init vector" from Bengt Jonsson, so
> it would be nice to get an Ack from him.

Good idea.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog


