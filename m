Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab2HBMph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 08:45:37 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41284 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab2HBMpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 08:45:36 -0400
Message-ID: <501A766C.1060502@linaro.org>
Date: Thu, 02 Aug 2012 13:45:32 +0100
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
References: <1343741953-17828-1-git-send-email-lee.jones@linaro.org> <1343741953-17828-19-git-send-email-lee.jones@linaro.org> <20120731135539.GO4468@opensource.wolfsonmicro.com> <5017F2E2.4040100@linaro.org> <20120731151024.GA4468@opensource.wolfsonmicro.com>
In-Reply-To: <20120731151024.GA4468@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/12 16:10, Mark Brown wrote:
> On Tue, Jul 31, 2012 at 03:59:46PM +0100, Lee Jones wrote:
>> On 31/07/12 14:55, Mark Brown wrote:
>
>>>> +Optional properties:
>>>> + - interrupts       : The interrupt outputs from the device.
>
>>> If there's more than one interrupt then how are they ordered?
>
>> It doesn't matter. If there are any more than one (which there
>> aren't in this case), we usually use the interrupt-names property
>> then request them by name in the driver.
>
> So the binding therefore needs to say "The interrupt output from the
> device" as there's only one output supported.  If we were using
> interrupt-names then we'd need to document what the supported names are.

Okay, I've changed 'outputs' to 'output'.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
