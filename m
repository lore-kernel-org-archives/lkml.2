Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab2EHMlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:41:39 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:60513 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab2EHMl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:41:27 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4FA9146F.5050802@cam.ac.uk>
Date: Tue, 08 May 2012 13:41:19 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
CC: Masanari Iida <standby24x7@gmail.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Subject: Re: [PATCH] staging, iio: Fix typo in iio
References: <1336407522-13818-1-git-send-email-standby24x7@gmail.com> <544AC56F16B56944AEC3BD4E3D5917714E797B53AE@LIMKCMBX1.ad.analog.com>
In-Reply-To: <544AC56F16B56944AEC3BD4E3D5917714E797B53AE@LIMKCMBX1.ad.analog.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/2012 8:35 PM, Hennerich, Michael wrote:
> Masanari Iida wrote on 2012-05-07:
>> Correct spelling typo in staging/iio
>>
>> Signed-off-by: Masanari Iida<standby24x7@gmail.com>
> Acked-by: Michael Hennerich<michael.hennerich@analog.com>
Acked-by: Jonathan Cameron <jic23@kernel.org>

Please send to Gregkh@linuxfoundation.org
>> ---
>>   drivers/staging/iio/TODO                      | 2 +-
>>   drivers/staging/iio/gyro/adxrs450.h           | 2 +-
>>   drivers/staging/iio/iio_simple_dummy_buffer.c | 4 ++--
>>   drivers/staging/iio/iio_simple_dummy_events.c | 2 +-
>>   4 files changed, 5 insertions(+), 5 deletions(-)
>> diff --git a/drivers/staging/iio/TODO b/drivers/staging/iio/TODO
>> index d1ad35e..cf3f948 100644
>> --- a/drivers/staging/iio/TODO
>> +++ b/drivers/staging/iio/TODO
>> @@ -67,7 +67,7 @@ e-mailing the normal IIO list (see below).
>>
>>   Documentation
>>   1) Lots of cleanup and expansion.
>> -2) Some device require indvidual docs.
>> +2) Some device require individual docs.
>>
>>   Contact: Jonathan Cameron<jic23@cam.ac.uk>.
>>   Mailing list: linux-iio@vger.kernel.org
>> diff --git a/drivers/staging/iio/gyro/adxrs450.h
>> b/drivers/staging/iio/gyro/adxrs450.h index af0c870..f8cf21f 100644 ---
>> a/drivers/staging/iio/gyro/adxrs450.h +++
>> b/drivers/staging/iio/gyro/adxrs450.h @@ -49,7 +49,7 @@ enum {
>>    * @us:                      actual spi_device
>>    * @buf_lock:                mutex to protect tx and rx
>>    * @tx:                      transmit buffer
>> - * @rx:                      recieve buffer
>> + * @rx:                      receive buffer
>>    **/
>>   struct adxrs450_state {
>>        struct spi_device       *us;
>> diff --git a/drivers/staging/iio/iio_simple_dummy_buffer.c
>> b/drivers/staging/iio/iio_simple_dummy_buffer.c index bb4daf7..389c18a
>> 100644 --- a/drivers/staging/iio/iio_simple_dummy_buffer.c +++
>> b/drivers/staging/iio/iio_simple_dummy_buffer.c @@ -37,7 +37,7 @@ static
>> const s16 fakedata[] = {
>>    * @irq: the interrupt number
>>    * @p: private data - always a pointer to the poll func.
>>    *
>> - * This is the guts of buffered capture. On a trigger event occuring,
>> + * This is the guts of buffered capture. On a trigger event occurring,
>>    * if the pollfunc is attached then this handler is called as a
>>    threaded * interrupt (and hence may sleep). It is responsible for
>>    grabbing data * from the device and pushing it into the associated
>>    buffer.
>> @@ -64,7 +64,7 @@ static irqreturn_t iio_simple_dummy_trigger_h(int
>> irq, void *p)
>>                 *   up a fast read.  The capture will consist of all of them.           *
>>   Hence we just call the grab data function and fill the                *   buffer
>>   without processing.
>> -              * sofware scans: can be considered to be random access
>> +              * software scans: can be considered to be random access
>>                 *   so efficient reading is just a case of minimal bus
>>                 *   transactions.
>>                 * software culled hardware scans:
>> diff --git a/drivers/staging/iio/iio_simple_dummy_events.c
>> b/drivers/staging/iio/iio_simple_dummy_events.c index 449c7a5..368317b
>> 100644 --- a/drivers/staging/iio/iio_simple_dummy_events.c +++
>> b/drivers/staging/iio/iio_simple_dummy_events.c @@ -122,7 +122,7 @@ int
>> iio_simple_dummy_write_event_value(struct iio_dev *indio_dev,
>>    * @private: pointer to device instance state.
>>    *
>>    * This handler is responsible for querying the device to find out
>> what
>> - * event occured and for then pushing that event towards userspace.
>> + * event occurred and for then pushing that event towards userspace.
>>    * Here only one event occurs so we push that directly on with locally
>>    * grabbed timestamp.
>>    */
> Greetings,
> Michael
>
> --
> Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
> Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368;
> Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin, Margaret Seif
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

