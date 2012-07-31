Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab2GaO7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:59:50 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62469 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab2GaO7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:59:49 -0400
Message-ID: <5017F2E2.4040100@linaro.org>
Date: Tue, 31 Jul 2012 15:59:46 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 18/19] Documentation: Define the MSP Driver Device Tree
 bindings
References: <1343741953-17828-1-git-send-email-lee.jones@linaro.org> <1343741953-17828-19-git-send-email-lee.jones@linaro.org> <20120731135539.GO4468@opensource.wolfsonmicro.com>
In-Reply-To: <20120731135539.GO4468@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/12 14:55, Mark Brown wrote:
> On Tue, Jul 31, 2012 at 02:39:12PM +0100, Lee Jones wrote:
>
>> +Optional properties:
>> + - interrupts       : The interrupt outputs from the device.
>
> If there's more than one interrupt then how are they ordered?

It doesn't matter. If there are any more than one (which there aren't in 
this case), we usually use the interrupt-names property then request 
them by name in the driver.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
