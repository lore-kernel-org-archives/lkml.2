Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309Ab1CWKYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:24:39 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:2620 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab1CWKYh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:24:37 -0400
X-IronPort-AV: E=Sophos;i="4.63,230,1299474000"; 
   d="scan'208";a="31143654"
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Cai, Cliff" <Cliff.Cai@analog.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Drivers <Drivers@analog.com>, "Cai, Cliff" <Cliff.Cai@analog.com>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Date: Wed, 23 Mar 2011 10:24:33 +0000
Subject: RE: [Device-drivers-devel] [PATCH 3/3] Add ABI document for gyro
	quadrature correction
Thread-Topic: [Device-drivers-devel] [PATCH 3/3] Add ABI document for gyro
	quadrature correction
Thread-Index: AcvpQxTeQlG9CKRYSByXSfS5DiOhNwAATmdQ
Message-ID: <544AC56F16B56944AEC3BD4E3D5917713754316021@LIMKCMBX1.ad.analog.com>
References: <1300871727-32239-1-git-send-email-cliff.cai@analog.com>
 <1300871727-32239-3-git-send-email-cliff.cai@analog.com>
In-Reply-To: <1300871727-32239-3-git-send-email-cliff.cai@analog.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cliff.cai@analog.com wrote on 2011-03-23:
> From: Cliff Cai <cliff.cai@analog.com>
>
> Add ABI description for gyro_z_quadrature_correction_raw.
>
> Signed-off-by: Cliff Cai <cliff.cai@analog.com>
> ---
>  drivers/staging/iio/Documentation/sysfs-bus-iio |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio
> b/drivers/staging/iio/Documentation/sysfs-bus-iio index 4915aee..1d42837
> 100644 --- a/drivers/staging/iio/Documentation/sysfs-bus-iio +++
> b/drivers/staging/iio/Documentation/sysfs-bus-iio @@ -698,3 +698,10 @@
> Description:
>               with all _en attributes to establish which channels are present,
>               and the relevant _type attributes to establish the data storage
>               format.
 + +What:       /sys/bus/iio/devices/deviceX/gyro_z_quadrature_correction_raw
 +KernelVersion:        2.6.38 +Contact:        linux-iio@vger.kernel.org +Description:
 +              This attribute is used to read the amount of quadrature error
 +              present in the device at a iven time.

Typo - 'given time'.


Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368; Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin, Margaret Seif

