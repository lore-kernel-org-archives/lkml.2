Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab1IGRBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:01:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:9086 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461Ab1IGQ7v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:59:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="45854135"
From: "Nallasellan, Singaravelan" <singaravelan.nallasellan@intel.com>
To: Arjan van de Ven <arjan@infradead.org>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 7 Sep 2011 17:32:10 +0530
Subject: RE: Player Thread is not woken after period elapsed
Thread-Topic: Player Thread is not woken after period elapsed
Thread-Index: AcxtCqdZJ/pcEMh0Q7Ge5N2f18anPwAMqVaw
Message-ID: <3CA6C6D9F70D314CA34352990B57DA1507C42767FA@bgsmsx502.gar.corp.intel.com>
References: <3CA6C6D9F70D314CA34352990B57DA1507C420F147@bgsmsx502.gar.corp.intel.com>
	<20110905105253.2787b91f@infradead.org>
	<3CA6C6D9F70D314CA34352990B57DA1507C420F15C@bgsmsx502.gar.corp.intel.com>
	<20110905112225.72b46ac9@infradead.org>
	<3CA6C6D9F70D314CA34352990B57DA1507C4275D58@bgsmsx502.gar.corp.intel.com>
 <20110906200614.57a99d3d@infradead.org>
In-Reply-To: <20110906200614.57a99d3d@infradead.org>
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


> 
> > >
> > > Please always test bugs like this with a recent kernel. 2.6.35 is
> > > pretty much 6 versions (and 18 months) behind and at that point you
> > > really have to test with something newer first before asking others
> > > to help you and spend their time on your problem.
> > >
> > Unfortunately, I am stuck with that version as the product that I work
> > on is on that version.
> 
> and that is everyone elses problem ... how?
> 
> if you can't be bothered to try at least a recent kernel, why would anyone else
> be bothered to help you on their own time?????
> 
I completely agree with you. Sorry for the inconvenience. But I have no choice. 
Further investigation of this issue shows that the thread is in running state and it is not scheduled. I am not sure how I will go about debugging this issue. Any pointer would help. 
> 
> --
