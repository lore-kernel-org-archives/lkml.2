Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab2I0GNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 02:13:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:61905 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855Ab2I0GNf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 02:13:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,493,1344236400"; 
   d="scan'208";a="198412667"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Thermal: Update binding logic based on platform data
Thread-Topic: Thermal: Update binding logic based on platform data
Thread-Index: AQHNm1xNNGcqo2xlFEiG+5KMflFOL5ecsiGQ///RZwCAATO3kA==
Date: Thu, 27 Sep 2012 06:13:16 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB591D3D26@BGSMSX101.gar.corp.intel.com>
References: <20120925202747.GA19537@elgon.mountain>
 <4D68720C2E767A4AA6A8796D42C8EB591D3756@BGSMSX101.gar.corp.intel.com>
 <20120926172029.GQ13767@mwanda>
In-Reply-To: <20120926172029.GQ13767@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Wednesday, September 26, 2012 10:51 PM
> To: R, Durgadoss
> Cc: Zhang, Rui; linux-kernel@vger.kernel.org
> Subject: Re: Thermal: Update binding logic based on platform data
> 
> On Wed, Sep 26, 2012 at 02:39:22PM +0000, R, Durgadoss wrote:
> > Hi,
> >
> > > -----Original Message-----
> > > From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> > > Sent: Wednesday, September 26, 2012 1:58 AM
> > > To: R, Durgadoss
> > > Cc: Zhang, Rui; linux-kernel@vger.kernel.org
> > > Subject: re: Thermal: Update binding logic based on platform data
> > >
> > > Hello Durgadoss R,
> > >
> > > This is a semi-automatic email about new static checker warnings.
> > >
> > > The patch 9b70dfa68ae8: "Thermal: Update binding logic based on
> > > platform data" from Sep 18, 2012, leads to the following Smatch
> > > complaint:
> >
> > looking into this. Will submit appropriate fix patches soon.
> >
> > Is there a way for me to check/verify these kind of warnings from
> > my side ? This way, I can do the check before I submit each patch.
> >
> 
> Sure:
> 
> git clone git://repo.or.cz/smatch.git
> cd smatch
> make
> (no make install needed)
> cd /to/kernel/src/
> ~/path/to/smatch/smatch_scripts/kchecker drivers/thermal/thermal_sys.c

Thanks Dan, That worked great, and I just submitted a patch fixing all the
warnings from smatch.

I will ensure that I run this before I submit patches, going forward.
Thanks for a nice tool :-)

Thanks,
Durga
