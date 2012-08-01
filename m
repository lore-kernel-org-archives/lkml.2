Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab2HAHhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 03:37:09 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34049 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab2HAHhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 03:37:06 -0400
Message-ID: <5018DC9F.30502@linaro.org>
Date: Wed, 01 Aug 2012 08:37:03 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org,
        linus.walleij@stericsson.com, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com, olalilja@yahoo.se,
        STEricsson_nomadik_linux@list.st.com, lrg@ti.com
Subject: Re: [PATCH 3/6] ARM: ux500: Fix merge error, so such struct 'snd_soc_u8500'
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org> <1343741493-17671-6-git-send-email-lee.jones@linaro.org> <50180BF6.6080908@mvista.com>
In-Reply-To: <50180BF6.6080908@mvista.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/12 17:46, Sergei Shtylyov wrote:
> Hello.
> 
> On 07/31/2012 05:31 PM, Lee Jones wrote:
> 
>    Subject doesn't parse for me...
> 
>> The platform attempts to register platform device 'snd_soc_u8500'
>> which doesn't actually exist. Here we change the reference to the
>> correct one 'snd_soc_mop500'.
> 
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Actually, it does make sense?

As a sentence: "This patch fixes merge error: so such structure 'struct snd_soc_u8500'.


-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
