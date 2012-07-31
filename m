Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab2GaPAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 11:00:21 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52573 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab2GaPAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 11:00:19 -0400
Message-ID: <5017F300.8020206@linaro.org>
Date: Tue, 31 Jul 2012 16:00:16 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 17/19] Documentation: Define the MOP500 Audio Machine
 Driver Device Tree bindings
References: <1343741953-17828-1-git-send-email-lee.jones@linaro.org> <1343741953-17828-18-git-send-email-lee.jones@linaro.org> <20120731135337.GM4468@opensource.wolfsonmicro.com>
In-Reply-To: <20120731135337.GM4468@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/12 14:53, Mark Brown wrote:
> On Tue, Jul 31, 2012 at 02:39:11PM +0100, Lee Jones wrote:
>
>> +Required properties:
>> + - compatible                : "stericsson,snd-soc-mop500"
>
>> +Non-standard properties:
>> + - Machine Driver:
>> +   - stericsson,cpu-dai      : Phandle to the CPU-side DAI
>> +   - stericsson,audio-codec  : Phandle to the Audio CODEC
>
> You should also support the card name property (there's a helper to
> parse it, you can define the name of the property though) so apps can
> tell what board they're on.

Okay.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
