Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862Ab2DJTDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 15:03:45 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:49804 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758337Ab2DJTDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 15:03:43 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4F84840B.9080104@cam.ac.uk>
Date: Tue, 10 Apr 2012 20:03:39 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120314 Thunderbird/11.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jon Brenner <jbrenner@taosinc.com>, linux-iio <linux-iio@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V5] TAOS tsl2x7x
References: <1333385439.2151.1.camel@jonz-ub2> <20120410173608.GA29862@kroah.com>
In-Reply-To: <20120410173608.GA29862@kroah.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 06:36 PM, Greg KH wrote:
> On Mon, Apr 02, 2012 at 11:50:39AM -0500, Jon Brenner wrote:
>> TAOS device driver (version 5) for the tsl/tmd 2771 and 2772 device families (inc. all variants).
>>
>> Signed-off-by: Jon Brenner <jbrenner@taosinc.com>
>> ---
>>  .../light/sysfs-bus-iio-light-tsl2583              |    6 +
>>  .../light/sysfs-bus-iio-light-tsl2x7x              |   14 +
>>  drivers/staging/iio/Documentation/sysfs-bus-iio    |    7 +
>>  .../staging/iio/Documentation/sysfs-bus-iio-light  |    8 +-
>>  .../iio/Documentation/sysfs-bus-iio-light-tsl2583  |   20 -
>>  drivers/staging/iio/light/Kconfig                  |    8 +
>>  drivers/staging/iio/light/Makefile                 |    2 +
>>  drivers/staging/iio/light/tsl2x7x.h                |   99 ++
>>  drivers/staging/iio/light/tsl2x7x_core.c           | 1830 ++++++++++++++++++++
>>  9 files changed, 1970 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2583 b/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2583
>> new file mode 100644
>> index 0000000..8f2a038
>> --- /dev/null
>> +++ b/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2583
>> @@ -0,0 +1,6 @@
>> +What:		/sys/bus/iio/devices/device[n]/illuminance0_calibrate
>> +KernelVersion:	2.6.37
> 
> Really?  Are we traveling back in time now?
> 
> confused...
> 
> I need an ack from Jonathan before I can take this.
That is a little curious given the entry is already in that file as far
as I can see (and was indeed introduced back in 2.6.37 given these are
docs for a different driver). Something weird gone wrong moving that
to the other file Jon?

More importantly Jon is still working on this driver (we were exchanging
emails about it a couple of days ago and I think I owe
Jon a reply to the last one (oops)    It was nearly there so I'd imagine
you'll get a v6 or 7 in a few days...

> 
> thanks,
> 
> greg k-h

