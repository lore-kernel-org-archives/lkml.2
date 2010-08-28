Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab0H1BfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 21:35:18 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47749 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab0H1BfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 21:35:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6087"; a="52527748"
Message-ID: <4C7867D4.10404@codeaurora.org>
Date: Fri, 27 Aug 2010 18:35:16 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Arnd Bergmann <arnd@arndb.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ARM: uaccess: Implement strict user copy checks
References: <4C61EE55.5030506@codeaurora.org>	<201008251414.16411.arnd@arndb.de>	<20100825125451.GH2153@osiris.boeblingen.de.ibm.com>	<201008251555.53653.arnd@arndb.de> <20100825144040.GI2153@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20100825144040.GI2153@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2010 07:40 AM, Heiko Carstens wrote:
> On Wed, Aug 25, 2010 at 03:55:53PM +0200, Arnd Bergmann wrote:
>>
>> If you don't want to see the warnings, then just remove the strict checks.
>> We already concluded that there is little value in them on s390 since it only
>> shows false postives.
>>
>> Maybe the easiest way would be to rename the option on s390 and move all
>> the other ones into a common place.
> 
> Yes, feel free to do that.
> 

Can you put up the false positives somewhere? I don't have easy access
to an s390 toolchain to test build with and I'm interested to see how
bad the false positives are.

I'm slightly concerned that we'll just have this problem again when
another arch comes along with false positives. But ignoring that issue
is probably fine. I'll respin with a patch to move s390 to something
like DEBUG_WARN_USER_COPY_CHECKS.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
