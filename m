Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab1CWLS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 07:18:58 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:58628 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487Ab1CWLS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 07:18:57 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D89D76C.2040509@cam.ac.uk>
Date: Wed, 23 Mar 2011 11:20:12 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
CC: "Cai, Cliff" <Cliff.Cai@analog.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Drivers <Drivers@analog.com>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Subject: Re: [Device-drivers-devel] [PATCH 3/3] Add ABI document for gyro
 quadrature correction
References: <1300871727-32239-1-git-send-email-cliff.cai@analog.com> <1300871727-32239-3-git-send-email-cliff.cai@analog.com> <544AC56F16B56944AEC3BD4E3D5917713754316021@LIMKCMBX1.ad.analog.com>
In-Reply-To: <544AC56F16B56944AEC3BD4E3D5917713754316021@LIMKCMBX1.ad.analog.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/11 10:24, Hennerich, Michael wrote:
> cliff.cai@analog.com wrote on 2011-03-23:
>> From: Cliff Cai <cliff.cai@analog.com>
>>
>> Add ABI description for gyro_z_quadrature_correction_raw.
>>
>> Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

(after fixing the typo of course ;)
>> ---
>>  drivers/staging/iio/Documentation/sysfs-bus-iio |    7 +++++++
>>  1 files changed, 7 insertions(+), 0 deletions(-)
>> diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio
>> b/drivers/staging/iio/Documentation/sysfs-bus-iio index 4915aee..1d42837
>> 100644 --- a/drivers/staging/iio/Documentation/sysfs-bus-iio +++
>> b/drivers/staging/iio/Documentation/sysfs-bus-iio @@ -698,3 +698,10 @@
>> Description:
>>               with all _en attributes to establish which channels are present,
>>               and the relevant _type attributes to establish the data storage
>>               format.
>  + +What:       /sys/bus/iio/devices/deviceX/gyro_z_quadrature_correction_raw
>  +KernelVersion:        2.6.38 +Contact:        linux-iio@vger.kernel.org +Description:
>  +              This attribute is used to read the amount of quadrature error
>  +              present in the device at a iven time.
> 
> Typo - 'given time'.
Guessing we don't have any real 'units' for this measurement?  Pity.

> 
> 
> Greetings,
> Michael
> 
> --
> Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
> Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368; Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin, Margaret Seif
> 
> 

