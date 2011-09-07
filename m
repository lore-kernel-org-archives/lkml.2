Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab1IGSUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 14:20:09 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:45561 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab1IGSUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 14:20:08 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E67B7C7.8060800@cam.ac.uk>
Date: Wed, 07 Sep 2011 19:28:23 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110901 Thunderbird/6.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, Michael.Hennerich@analog.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 1/6] SPI: add ability to say we want a cs change after
 every transfer.
References: <4E679770.4090008@cam.ac.uk> <1315412387-5765-2-git-send-email-jic23@cam.ac.uk> <20110907173515.GF2906@opensource.wolfsonmicro.com> <4E67B477.7060602@cam.ac.uk> <20110907181236.GI2906@opensource.wolfsonmicro.com>
In-Reply-To: <20110907181236.GI2906@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/11 19:12, Mark Brown wrote:
> On Wed, Sep 07, 2011 at 07:14:15PM +0100, Jonathan Cameron wrote:
>> On 09/07/11 18:35, Mark Brown wrote:
> 
>>> We could add this in regmap if required.
> 
>> Makes more sense in spi and has been in their 'may be needed comment'
>> from the first.  Also, lots of other users who don't fit into regmap
>> (because they don't have any registers to speak of :)
> 
> Right, but obviously anything doing SPI transfers can just set the flag
> in the transfers anyway.  It looked like you were adding this to the
> core due to other intervening abstractions, probably this is just a
> problem with your changelog.
I'll make it clearer that it has uses there elsewhere as well not to
mention merely stopping stupid bugs in drivers where this is always
needed.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

