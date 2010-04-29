Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab0D3Rni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:43:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:55720 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933466Ab0D3RnJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:43:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,297,1270450800"; 
   d="scan'208";a="562803385"
From: "Epshteyn, Eugene" <eugene.epshteyn@intel.com>
To: Greg KH <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 29 Apr 2010 13:48:25 -0700
Subject: RE: [RFC PATCH 1/4] Mobile security processor driver
Thread-Topic: [RFC PATCH 1/4] Mobile security processor driver
Thread-Index: AcrnTVDKGUXWc8bGTGikvQ3OhCA3cAAjzlTw
Message-ID: <753F67ADE6F5094C9F1DBA00D1BAA8D32551825DAC@orsmsx501.amr.corp.intel.com>
References: <753F67ADE6F5094C9F1DBA00D1BAA8D325518252AC@orsmsx501.amr.corp.intel.com>
 <20100429033625.GA27503@kroah.com>
In-Reply-To: <20100429033625.GA27503@kroah.com>
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

Hi Greg,

Mark asked me to post the patches for him.

These patches are on 2.6.34 with the 0415 next patch.

We were hoping to get more comments from people to add to TODO list, so that the vendor can plan their work to fix the issues and make the driver more acceptable to the community.  The driver already went through some clean-up, but much more work is still needed.

Thanks,

--Eugene

-----Original Message-----
From: Greg KH [mailto:greg@kroah.com]
Sent: Wednesday, April 28, 2010 8:36 PM
To: Epshteyn, Eugene
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] Mobile security processor driver

On Wed, Apr 28, 2010 at 04:10:34PM -0700, Epshteyn, Eugene wrote:
> >From ea67f69e70e5a8c6e50db3f1d8b62cd52d816bc6 Mon Sep 17 00:00:00 2001
> From: Mark Allyn <mark.a.allyn@intel.com>
> Date: Wed, 28 Apr 2010 14:33:16 -0700
> Subject: RFC [PATCH 1/4] staging: sep: header file updates for 12/09 software release
>
> Signed-off-by: Mark A. Allyn <mark.a.allyn@intel.com>

Why are you posting Mark's patches?

There is no description of what these patches actually do.

Are you wanting them to be applied?

Why have you listed all of the patches with the same subject?

What exactly are you expecting to happen here?

totally confused,

greg k-h


p.s., I think this patch is completly wrong, based on one part:

> @@ -25,401 +31,576 @@
>    *
>    *  CHANGES:
>    *
> - *  2009.06.26 Initial publish
> + *  2010.01.08 Initial publish

the code was already published, this can't be an "initial publication"
again :)

What did you diff these against?
