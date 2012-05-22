Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760279Ab2EVT0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 15:26:49 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:2430 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab2EVT0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 15:26:47 -0400
Message-ID: <4FBBE83E.9090307@cavium.com>
Date: Tue, 22 May 2012 12:25:50 -0700
From: David Daney <david.daney@cavium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: David Daney <ddaney.cavm@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        Fleming Andy-AFLEMING <afleming@freescale.com>
Subject: Re: [PATCH 5/5] netdev/phy: Add driver for Cortina cs4321 quad 10G
 PHY.
References: <1337709592-23347-1-git-send-email-ddaney.cavm@gmail.com> <1337709592-23347-6-git-send-email-ddaney.cavm@gmail.com> <20120522185032.GR4038@decadent.org.uk>
In-Reply-To: <20120522185032.GR4038@decadent.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 May 2012 19:25:51.0178 (UTC) FILETIME=[B2CAB2A0:01CD3850]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 11:50 AM, Ben Hutchings wrote:
> On Tue, May 22, 2012 at 10:59:52AM -0700, David Daney wrote:
> [...]
>> --- /dev/null
>> +++ b/drivers/net/phy/cs4321-ucode.h
>> @@ -0,0 +1,4378 @@
>> +/*
>> + *    Copyright (C) 2011 by Cortina Systems, Inc.
>> + *
>> + *    This program is free software; you can redistribute it and/or modify
>> + *    it under the terms of the GNU General Public License as published by
>> + *    the Free Software Foundation; either version 2 of the License, or
>> + *    (at your option) any later version.
>> + *
>> + *    This program is distributed in the hope that it will be useful,
>> + *    but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + *    GNU General Public License for more details.
>> + *
>> + */
> [...]
>
> So where's the real source code for it?

I wish I knew.  The vendor released the array of random numbers as GPL 
to us. :-(

>
> If you won't (or can't) provide source code for the microcode then it
> should instead be submitted to linux-firmware with a binary
> redistribution licence, and the driver should load it with
> request_firmware().

I will attempt to do that.

The .c file contains plenty of other pseudo-random numbers, but those 
cannot really be considered 'firmware'

David Daney
