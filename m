Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab2IQIqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:46:36 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46878 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584Ab2IQIqe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:46:34 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Jonathan Cameron <jic23@kernel.org>
CC: Jonathan Cameron <jic23@jic23.retrosnub.co.uk>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] iio: inkern: add error case in iio_channel_get()
Thread-Topic: [PATCH 2/2] iio: inkern: add error case in iio_channel_get()
Thread-Index: Ac2PKqkZZFI0lKCnQcyWC+Ovo9lkG///jomA//nBTOCADHlVgP/6v+GA
Date: Mon, 17 Sep 2012 08:46:15 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF50BA@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF45EB@DQHE02.ent.ti.com>
 <504DAFF7.1070902@jic23.retrosnub.co.uk>
 <A874F61F95741C4A9BA573A70FE3998F41EF4C19@DQHE02.ent.ti.com>
 <5052E9A3.9030200@kernel.org>
In-Reply-To: <5052E9A3.9030200@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fine, I'm convinced.  Certainly less weird doing it your way ;)
> Please do fix up the get all case as well.

Please refer to chained patches.
[PATCH 1/2] iio: inkern: add error case in iio_channel_get()
[PATCH 2/2] iio: inkern: put the IIO device when mem alloc gets failed

I'd like to mention that these patches are dependent on another fix as below.
[PATCH RESEND] iio: inkern: allocate zeroed memory

Please let me know if any conflicts.

Thanks !

Best Regards,
Milo
