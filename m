Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab2K0HHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 02:07:33 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53475 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758083Ab2K0HHb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 02:07:31 -0500
From: "Patil, Rachna" <rachna@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: RE: [PATCH RESEND 3/7] input: ti_am335x_tsc: Add variance filter
Thread-Topic: [PATCH RESEND 3/7] input: ti_am335x_tsc: Add variance filter
Thread-Index: AQHNvLaHS3Y6p/3z8EiGtXIveRVoaZf0V98AgAkI9JA=
Date: Tue, 27 Nov 2012 07:07:12 +0000
Message-ID: <4CE347531D4CA947960AF71FF095B9323E96FBB2@DBDE01.ent.ti.com>
References: <1352271124-5513-1-git-send-email-rachna@ti.com>
 <1352271124-5513-4-git-send-email-rachna@ti.com>
 <20121121183350.GB18950@core.coreip.homeip.net>
In-Reply-To: <20121121183350.GB18950@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 00:03:50, Dmitry Torokhov wrote:
> Hi Rachna,

Hi Dmitry,

> 
> On Wed, Nov 07, 2012 at 12:22:00PM +0530, Patil, Rachna wrote:
> > Only fine tuning variance parameter present in tslib utility does not 
> > help in removing all the ADC noise.
> > This logic of filtering is necessary to get this touchscreen to work 
> > finely.
> 
> No, if filtering in tslib is not adequate please fix tslib so that your work is usable for other devices as well.

For now I will drop this patch from the patch set and send across the next version of the set with review comments on remaining patches addressed.
I will take up tslib separately.

Regards,
Rachna

> 
> Thanks.
> 
> --
> Dmitry
> 

