Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab2I3XWJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 19:22:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:18669 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab2I3XWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 19:22:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,514,1344236400"; 
   d="scan'208";a="228854853"
Date: Mon, 1 Oct 2012 01:22:02 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: "Patil, Rachna" <rachna@ti.com>,
        "Datta, Shubhrajyoti" <shubhrajyoti@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH v4 5/5] MFD: ti_tscadc: add suspend/resume functionality
Message-ID: <20120930232202.GF12231@sortiz-mobl>
References: <1348636814-14129-1-git-send-email-rachna@ti.com>
 <1348636814-14129-6-git-send-email-rachna@ti.com>
 <5062A373.4000707@ti.com>
 <4CE347531D4CA947960AF71FF095B9323E95738D@DBDE01.ent.ti.com>
 <5066C45B.3000500@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5066C45B.3000500@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

On Sat, Sep 29, 2012 at 10:50:19AM +0100, Jonathan Cameron wrote:
> On 09/26/2012 11:09 AM, Patil, Rachna wrote:
> > Hi Shubhrajyoti,
> > 
> > On Wed, Sep 26, 2012 at 12:10:51, Datta, Shubhrajyoti wrote:
> >> On Wednesday 26 September 2012 10:50 AM, Patil, Rachna wrote:
> >>> This patch adds support for suspend/resume of
> >>> TSC/ADC MFDevice.
> >> this should be merged with the patch adding support else
> >> we may end up in a case where patch a does the runtime calls
> >> and the call back  handlers added later.
> > 
> > I am adding both the runtime calls and the handlers in this patch.
> > I think maintaining this as a separate patch in better in terms
> > of readability as well.
> I would prefer this merged into patch 4 as it's a simple addition to
> a driver that should arguably have been there in the first place.
I agree. And I would even go as far as saying that having all the MFD parts
from this patchset merged into patch #2 would make sense.
Rachna, could you please re-work this patchset in such way, and adress my
comments on patch #2 ? I could then take the MFD parts and then Jonathan and
Dmitry take their parts. There are build time dependencies, but neither the
input nor the ADC driver could be actually built as long as the MFD one is not
merged (provided that the subdevices driver comes with the right Kconfig
dependecy).

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
