Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab2FKK2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 06:28:00 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60263 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab2FKK16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 06:27:58 -0400
Message-ID: <4FD5C829.2090408@linaro.org>
Date: Mon, 11 Jun 2012 11:27:53 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Chris Ball <cjb@laptop.org>, Linus Walleij <linus.walleij@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, sameo@linux.intel.com,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org, arnd@arndb.de,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 08/22] regulator: Change ab8500 match names to reflect
 Device Tree
References: <20120530100302.GD9947@opensource.wolfsonmicro.com> <CAF2Aj3gZMF9ev9B46rBM+aY-srwthef09ad2CWfuXXFHmqqAjA@mail.gmail.com> <20120530121547.GJ9947@opensource.wolfsonmicro.com> <4FC63632.4030504@linaro.org> <20120530151119.GN9947@opensource.wolfsonmicro.com> <4FC63B39.6040905@linaro.org> <20120530164152.GP9947@opensource.wolfsonmicro.com> <4FC846CC.20801@linaro.org> <20120601084850.GJ24139@opensource.wolfsonmicro.com> <4FCDDFFC.3000902@linaro.org> <20120605103846.GQ23408@opensource.wolfsonmicro.com>
In-Reply-To: <20120605103846.GQ23408@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/12 11:38, Mark Brown wrote:
> On Tue, Jun 05, 2012 at 11:31:24AM +0100, Lee Jones wrote:
>> On 01/06/12 09:48, Mark Brown wrote:
>
>>> What makes you say the two are equivalent?  The former is a reference
>> >from a consumer device to a named regulator while the latter is a
>>> reference from a regulator to a named consumer.
>
>> I mean they both link regulator<->consumer and apply the name "vmmc"
>> to the supply, or am I missing something / getting confused?
>
> You're missing something - note what I say above about the direction the
> mapping is done in, and consider what happens if we've got two of the
> same PMIC down in a system.

I'm still not seeing how this would cause an issue. The only Device Tree 
nodes which will be parsed are the ones which are specified by a 
particular driver's compatible string, meaning that any other nodes 
referencing similar regulator/supply names would be ignored. In case I 
am still missing a critical point here, would you be kind enough to 
provide an example that we can work though together?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
