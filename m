Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab1LFXWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 18:22:44 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46655 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab1LFXWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 18:22:43 -0500
Message-ID: <4EDEA3BF.6020507@gmail.com>
Date: Tue, 06 Dec 2011 17:22:39 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Wolfgang Denk <wd@denx.de>, devicetree-discuss@lists.ozlabs.org,
        Heiko Schocher <hs@denx.de>, linux-kernel@vger.kernel.org,
        Vitaly Bordug <vbordug@ru.mvista.com>, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] drivers, char: add U-Boot bootcount driver
References: <1322991921-21096-1-git-send-email-hs@denx.de> <20111204114741.GA5788@pengutronix.de> <4EDCD7B2.5030409@denx.de> <20111206215056.GD14154@pengutronix.de> <20111206215609.5D1FF1A32820@gemini.denx.de> <20111206220620.GF14154@pengutronix.de>
In-Reply-To: <20111206220620.GF14154@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 04:06 PM, Wolfram Sang wrote:
> 
>>> bootcount itself is not a device. It is a feature of certain devices. And that
>>> needs to be implemented; possibly generic enough that it can work for register
>>> based, i2c based, and so forth, accesses.
>>
>> If "boot counter" is not a good name for such a device, then what name
>> would you suggest?
> 
> None.
> 
>> Or do you think a counter (which can be implemented in a number of
>> different ways, depending on hardware specifics) is not a device?
> 
> Yes.
> 
>> What would be such a device, then?
> 
> "maxim,ds1338"
> 
> Please have a look at the devicetree.org-wiki-page I just mentioned:
> 
> http://devicetree.org/Device_Tree_Usage
> 

Perhaps fs/pstore would be a good choice for the user space interface
(defining a new file bootcount). This can support any arbitrary backing
device although pretty much only ACPI is implemented.

Rob

