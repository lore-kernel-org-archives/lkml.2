Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab2IQRGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:06:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56647 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab2IQRGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:06:44 -0400
Message-ID: <505758A1.1050205@gmail.com>
Date: Mon, 17 Sep 2012 10:06:41 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Ivo Sieben <meltedpianoman@gmail.com>
CC: David Daney <ddaney.cavm@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 2/2] misc/at25: Add an .id_table to at25 to facilitate
 driver loading and binding.
References: <1345662238-15211-1-git-send-email-ddaney.cavm@gmail.com> <1345662238-15211-3-git-send-email-ddaney.cavm@gmail.com> <CAMSQXEHXG=DGT7egbSfdNb2VFTXS+HQ0DoaA2v9dTX_2zn2pZg@mail.gmail.com>
In-Reply-To: <CAMSQXEHXG=DGT7egbSfdNb2VFTXS+HQ0DoaA2v9dTX_2zn2pZg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2012 12:49 AM, Ivo Sieben wrote:
> Hi,
>
> 2012/8/22 David Daney <ddaney.cavm@gmail.com>:
>> From: David Daney <david.daney@cavium.com>
>>
>>   /*-------------------------------------------------------------------------*/
>> +static const struct spi_device_id at25_id[] = {
>> +       {"at25", 0},
>> +       {"m95256", 0},
>> +       { }
>> +};
>> +MODULE_DEVICE_TABLE(spi, at25_id);
>
> I use this driver for the ST M95040, M95020 & M95010 eeprom devices.
> So wouldn't it be better to use the "famliy" name for these chips
> ("m95" instead of "m95256").
>

These are matched against device tree compatible properties.  You could 
propose adding a generic "st,95xxx" compatible property and adding that 
to the at25_id list.  But I don't think we want to remove "m95256", as 
we have deployed devices using this binding.

David Daney

