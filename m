Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab2DXRbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:31:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:56271 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756733Ab2DXRbO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:31:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="92606925"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>, Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: RE: [EDAC PATCH v13 6/7] edac.h: Prepare to handle with generic
 layers
Thread-Topic: [EDAC PATCH v13 6/7] edac.h: Prepare to handle with generic
 layers
Thread-Index: AQHNHA2e4drkei19OkSnQ3ASg+FwI5apMDmAgAALcwCAAQ8KgIAAEmmAgAATNgCAAASGAIAABdUAgAAOWYCAACKNgP//mZyQ
Date: Tue, 24 Apr 2012 17:31:12 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F170F319D@ORSMSX104.amr.corp.intel.com>
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607133-30039-7-git-send-email-mchehab@redhat.com>
 <20120423174955.GH6147@aftab.osrc.amd.com> <4F959FDE.2070304@redhat.com>
 <20120424104059.GA11559@aftab.osrc.amd.com> <4F9692AD.8090000@redhat.com>
 <20120424125538.GC11559@aftab.osrc.amd.com> <4F96A696.40308@redhat.com>
 <20120424133242.GI11559@aftab.osrc.amd.com> <4F96B783.6060101@redhat.com>
 <20120424162743.GU11559@aftab.osrc.amd.com>
In-Reply-To: <20120424162743.GU11559@aftab.osrc.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @Tony: hey Tony, can you point us to an Intel document explaining how
> Sandy Bridge or NH or one of the new ones does the memory addressing wrt
> ranks, channels etc? Thanks.

Data sheets for the E5-26xx series (vol 1 & 2) are linked off this page:

http://www.intel.com/content/www/us/en/processors/xeon/xeon-processor-5000-sequence/Xeon5000TechnicalResources.html

volume 2, section 4.4 is where this stuff is described ... BUT I'm
not sure if everything needed made it into them from the internal docs (which
we let Mauro use to write the sb_edac.c driver and then got a special exemption
to let him post the driver before the public docs existed ... which means there
*might* be some things that are only publicly documented in the EDAC driver).

-Tony
