Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab2K0HO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 02:14:59 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48028 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758065Ab2K0HO5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 02:14:57 -0500
From: "Patil, Rachna" <rachna@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>
Subject: RE: [PATCH RESEND 0/7] MFD: ti_am335x_tscadc: DT support and TSC
 features addition
Thread-Topic: [PATCH RESEND 0/7] MFD: ti_am335x_tscadc: DT support and TSC
 features addition
Thread-Index: AQHNvLaFYth37bJQKUuCL1LM2boBnpfsUghggAfruYCACSXTAA==
Date: Tue, 27 Nov 2012 07:14:36 +0000
Message-ID: <4CE347531D4CA947960AF71FF095B9323E96FC06@DBDE01.ent.ti.com>
References: <1352271124-5513-1-git-send-email-rachna@ti.com>
 <4CE347531D4CA947960AF71FF095B9323E96C54A@DBDE01.ent.ti.com>
 <20121121170021.GE18738@sortiz-mobl>
In-Reply-To: <20121121170021.GE18738@sortiz-mobl>
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

Hi Samuel,

On Wed, Nov 21, 2012 at 22:30:21, Samuel Ortiz wrote:
> Hi Rachna,
> 
> On Fri, Nov 16, 2012 at 10:33:00AM +0000, Patil, Rachna wrote:
> > Hi,
> > 
> > This is just a gentle reminder of the patch set I had posted earlier viz.
> > "[PATCH RESEND 0/7] MFD: ti_am335x_tscadc: DT support and TSC features addition"
> > Can this patch set be pulled in if there are no review comments.
> > This patch set does not break anything existing, it just adds new features and DT support for the MFD core and its clients.
> I'm fine with the MFD part, but did you get Dmitry's ACK on the input ones ?

I received few comments from Dmitry, I will be sending out v2 soon. 

Regards,
Rachna

> 
> Cheers,
> Samuel.
> 
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
> 

