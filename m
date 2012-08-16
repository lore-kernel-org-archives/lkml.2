Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab2HPHt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 03:49:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45787 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab2HPHtZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 03:49:25 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Peter Meerwald <pmeerw@pmeerw.net>
CC: Jonathan Cameron <jic23@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: RE: [PATCH 1/3] iio: add iio_read_channel_offset() consumer api
Thread-Topic: [PATCH 1/3] iio: add iio_read_channel_offset() consumer api
Thread-Index: Ac17gj27zkdhHbJaQSqzTiFPSN7+Zf//erSA//95NgA=
Date: Thu, 16 Aug 2012 07:49:13 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EEFDA0@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EEFD6E@DQHE02.ent.ti.com>
 <alpine.DEB.2.01.1208160940380.3550@pmeerw.net>
In-Reply-To: <alpine.DEB.2.01.1208160940380.3550@pmeerw.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.52]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  int iio_read_channel_scale(struct iio_channel *chan, int *val,
> >  			   int *val2);
> >
> > +/**
> > + * iio_read_channel_offset() - read offset from a given channel
> > + * @channel:		The channel being queried.
> 
> the parameter is 'chan', not 'channel'
> 

Oops, this is copy-and-paste disaster.
The description of iio_read_channel_scale() also needs correction.
Thanks for catching this !

After getting other feedbacks, separate patch will be submitted.

Best Regards,
Milo
