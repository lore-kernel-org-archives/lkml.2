Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab0GWEZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 00:25:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:33100 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab0GWEZt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 00:25:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,245,1278313200"; 
   d="scan'208";a="820845477"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@linux.intel.com>
Date: Fri, 23 Jul 2010 09:55:15 +0530
Subject: RE: [PATCH 1/3] DMAENGINE: generic slave channel control v2
Thread-Topic: [PATCH 1/3] DMAENGINE: generic slave channel control v2
Thread-Index: Acsp9lFUGrAoMiYFQrGaMxVVVnt9aAAKHf1g
Message-ID: <438BB0150E931F4B9CE701519A44630104A39147D5@bgsmsx502.gar.corp.intel.com>
References: <1279740148-22186-1-git-send-email-linus.walleij@stericsson.com>
 <AANLkTik4htT0J6xvUHn5RzvjuxqgZSAWw7c7AnMLpLor@mail.gmail.com>
In-Reply-To: <AANLkTik4htT0J6xvUHn5RzvjuxqgZSAWw7c7AnMLpLor@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > + * @private_config: if you need to pass in specialized configuration
> > + * at runtime, apart from the generic things supported in this
> > + * struct, you provide it in this pointer and dereference it inside
> > + * your dmaengine driver to get the proper configuration bits out.
> > + *
> 
> Will there be any users of this field initially, I'd just as soon
> leave it out?  Like I mentioned to Vinod I think requiring
> dma_slave_config to be wrapped is a better way to extend this
> structure.
> 
I was thinking of moving some of structure fields into this, but yes wrapping 
this into device specific will be a better way

-Vinod
