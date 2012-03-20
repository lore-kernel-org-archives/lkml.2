Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab2CTQnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:43:00 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:47795 "HELO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751674Ab2CTQm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:42:58 -0400
Message-ID: <4F68B386.9050307@ti.com>
Date: Tue, 20 Mar 2012 22:12:46 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: spi-devel-general@lists.sourceforge.net, Shubhrajyoti@ponder.secretlab.ca,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] SPI updates
References: <1332239389-1897-1-git-send-email-shubhrajyoti@ti.com> <20120320162019.33AC83E2834@localhost>
In-Reply-To: <20120320162019.33AC83E2834@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 March 2012 09:50 PM, Grant Likely wrote:
> On Tue, 20 Mar 2012 15:59:46 +0530, Shubhrajyoti D <shubhrajyoti@ti.com> wrote:
>> The patch series does the following cleanups
>> - Converts the spi to module_platform_driver
>> - Use the devm functions so that the freeing need not 
>>   be done in the driver.
>>
>> This is also available through
>> git     : git://gitorious.org/linus-tree/linus-tree.git
>> branch  : spi
>>
>>
>> Felipe Balbi (2):
>>   spi: omap2-mcspi: make it behave as a module
>>   spi: omap2-mcspi: convert to module_platform_driver
>>
>> Shubhrajyoti D (1):
>>   spi: omap2-mcspi: use devm_* functions
>>
>>  drivers/spi/spi-omap2-mcspi.c |   46 ++++++++---------------------------------
>>  1 files changed, 9 insertions(+), 37 deletions(-)
> Merged for v3.5 (it's too late for v3.4)
>
> g.
Thanks Grant.

