Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928Ab1FWIqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 04:46:32 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:39620 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab1FWIqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 04:46:31 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E02FF41.1060000@cam.ac.uk>
Date: Thu, 23 Jun 2011 09:54:25 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH 0/8] Generic I2C and SPI register map library
References: <20110622184407.GC13847@sirena.org.uk> <20110622224828.GA2342@siel.b> <20110623012544.GE20949@opensource.wolfsonmicro.com>
In-Reply-To: <20110623012544.GE20949@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/11 02:25, Mark Brown wrote:
> On Thu, Jun 23, 2011 at 12:48:28AM +0200, torbenh wrote:
> 
>> you should look at SMBus 
>> there seems to be quite some code to share.
>> in particular i2c rtc devices seem to be using SMBus functions
>> to get the exact same semantics you are providing here.
> 
> SMBus is an I2C subset with a definition for 8 bit registers layered
> onto it, pretty much.
> 
>> I just added support for such a device today, and it struck me, that
>> this API was necessary.
> 
> If you're only using SMBus then the I2C interface includes SMBus based
> register support which should do what you want.  With the regmap API it
> ought to work as a device with 8 bit registers and 8 bit values.

The kicker here is that quite a few hosts only support the smbus subset.
How should that be handled here?
