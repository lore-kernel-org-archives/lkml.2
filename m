Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854Ab2EGTfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 15:35:12 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:58940
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932090Ab2EGTfK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 15:35:10 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: -9
X-BigFish: VPS-9(zz936eK1432Nzz1202hzz8275bh8275dhz2dh2a8h668h839h944hd25h)
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Masanari Iida <standby24x7@gmail.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Date: Mon, 7 May 2012 20:35:18 +0100
Subject: RE: [PATCH] staging, iio: Fix typo in iio
Thread-Topic: [PATCH] staging, iio: Fix typo in iio
Thread-Index: Ac0sbSIA5ssbNg2ETUWNsla0gsGGagAG1pew
Message-ID: <544AC56F16B56944AEC3BD4E3D5917714E797B53AE@LIMKCMBX1.ad.analog.com>
References: <1336407522-13818-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1336407522-13818-1-git-send-email-standby24x7@gmail.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masanari Iida wrote on 2012-05-07:
> Correct spelling typo in staging/iio
>
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
> ---
>  drivers/staging/iio/TODO                      | 2 +-
>  drivers/staging/iio/gyro/adxrs450.h           | 2 +-
>  drivers/staging/iio/iio_simple_dummy_buffer.c | 4 ++--
>  drivers/staging/iio/iio_simple_dummy_events.c | 2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
> diff --git a/drivers/staging/iio/TODO b/drivers/staging/iio/TODO
> index d1ad35e..cf3f948 100644
> --- a/drivers/staging/iio/TODO
> +++ b/drivers/staging/iio/TODO
> @@ -67,7 +67,7 @@ e-mailing the normal IIO list (see below).
>
>  Documentation
>  1) Lots of cleanup and expansion.
> -2) Some device require indvidual docs.
> +2) Some device require individual docs.
>
>  Contact: Jonathan Cameron <jic23@cam.ac.uk>.
>  Mailing list: linux-iio@vger.kernel.org
> diff --git a/drivers/staging/iio/gyro/adxrs450.h
> b/drivers/staging/iio/gyro/adxrs450.h index af0c870..f8cf21f 100644 ---
> a/drivers/staging/iio/gyro/adxrs450.h +++
> b/drivers/staging/iio/gyro/adxrs450.h @@ -49,7 +49,7 @@ enum {
>   * @us:                      actual spi_device
>   * @buf_lock:                mutex to protect tx and rx
>   * @tx:                      transmit buffer
> - * @rx:                      recieve buffer
> + * @rx:                      receive buffer
>   **/
>  struct adxrs450_state {
>       struct spi_device       *us;
> diff --git a/drivers/staging/iio/iio_simple_dummy_buffer.c
> b/drivers/staging/iio/iio_simple_dummy_buffer.c index bb4daf7..389c18a
> 100644 --- a/drivers/staging/iio/iio_simple_dummy_buffer.c +++
> b/drivers/staging/iio/iio_simple_dummy_buffer.c @@ -37,7 +37,7 @@ static
> const s16 fakedata[] = {
>   * @irq: the interrupt number
>   * @p: private data - always a pointer to the poll func.
>   *
> - * This is the guts of buffered capture. On a trigger event occuring,
> + * This is the guts of buffered capture. On a trigger event occurring,
>   * if the pollfunc is attached then this handler is called as a
>   threaded * interrupt (and hence may sleep). It is responsible for
>   grabbing data * from the device and pushing it into the associated
>   buffer.
> @@ -64,7 +64,7 @@ static irqreturn_t iio_simple_dummy_trigger_h(int
> irq, void *p)
>                *   up a fast read.  The capture will consist of all of them.           *
>  Hence we just call the grab data function and fill the                *   buffer
>  without processing.
> -              * sofware scans: can be considered to be random access
> +              * software scans: can be considered to be random access
>                *   so efficient reading is just a case of minimal bus
>                *   transactions.
>                * software culled hardware scans:
> diff --git a/drivers/staging/iio/iio_simple_dummy_events.c
> b/drivers/staging/iio/iio_simple_dummy_events.c index 449c7a5..368317b
> 100644 --- a/drivers/staging/iio/iio_simple_dummy_events.c +++
> b/drivers/staging/iio/iio_simple_dummy_events.c @@ -122,7 +122,7 @@ int
> iio_simple_dummy_write_event_value(struct iio_dev *indio_dev,
>   * @private: pointer to device instance state.
>   *
>   * This handler is responsible for querying the device to find out
> what
> - * event occured and for then pushing that event towards userspace.
> + * event occurred and for then pushing that event towards userspace.
>   * Here only one event occurs so we push that directly on with locally
>   * grabbed timestamp.
>   */

Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368;
Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin, Margaret Seif



