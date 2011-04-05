Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab1DETpB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 15:45:01 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:49476 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab1DETo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 15:44:57 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D9B7198.1090109@cam.ac.uk>
Date: Tue, 05 Apr 2011 20:46:32 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: cliff.cai@analog.com, gregkh@suse.de, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org
Subject: Re: [PATCH 1/2] staging: IIO driver for Analog Devices Digital Output
 Gyroscope ADXRS450
References: <1301025958-2175-1-git-send-email-cliff.cai@analog.com> <20110405192130.GA10106@kroah.com>
In-Reply-To: <20110405192130.GA10106@kroah.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/11 20:21, Greg KH wrote:
> On Fri, Mar 25, 2011 at 12:05:57PM +0800, cliff.cai@analog.com wrote:
>> From: Cliff Cai <cliff.cai@analog.com>
>>
>> Add new IIO driver for Analog Devices digital output gyroscope ADXRS450
>>
>> Signed-off-by: Cliff Cai <cliff.cai@analog.com>
>> Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> 
> This breaks the build:
>   CC [M]  drivers/staging/iio/gyro/adxrs450_core.o
> drivers/staging/iio/gyro/adxrs450_core.c:329:70: error: expected ‘)’ before numeric constant
> drivers/staging/iio/gyro/adxrs450_core.c:337:3: error: ‘iio_dev_attr_gyro_z_quadrature_correction_raw’ undeclared here (not in a function)
> drivers/staging/iio/gyro/adxrs450_core.c:216:16: warning: ‘adxrs450_read_quad’ defined but not used
> 
> Please test your patches before you send them out, it wastes everyone's
> time when you don't :(

First patch seems to have dropped off the start of this series.

The review version had:

[PATCH 1/3] Add MACRO for gyro quadrature correction

Guessing a typo in git command post adding acks
is the culprit here!
