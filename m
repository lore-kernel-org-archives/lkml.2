Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab1GNSKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 14:10:21 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18753 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab1GNSKU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 14:10:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 14 Jul 2011 11:09:48 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "bones@secretlab.ca" <bones@secretlab.ca>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Date: Thu, 14 Jul 2011 11:09:47 -0700
Subject: RE: [PATCH] i2c: tegra: Use engineering names in DT compatible
 property
Thread-Topic: [PATCH] i2c: tegra: Use engineering names in DT compatible
 property
Thread-Index: AcxBtVrn7OnWkQNlQ2eukX7gGSlEigAm0GSA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF049E834A2E@HQMAIL01.nvidia.com>
References: <1309897306-22953-1-git-send-email-swarren@nvidia.com>
 <20110706053941.GE9978@ponder.secretlab.ca>
 <74CDBE0F657A3D45AFBB94109FB122FF049E834757@HQMAIL01.nvidia.com>
 <CACxGe6tojgLSmHTxzGn3hZZVqiR_z6xbWrazYekm0TwQoWK5eA@mail.gmail.com>
In-Reply-To: <CACxGe6tojgLSmHTxzGn3hZZVqiR_z6xbWrazYekm0TwQoWK5eA@mail.gmail.com>
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

Grant Likely wrote at Wednesday, July 13, 2011 5:34 PM:
> On Thu, Jul 14, 2011 at 2:59 AM, Stephen Warren <swarren@nvidia.com> wrote:
...
> > I don't believe anyone ever sent a patch to Ben to add tegra_i2c_of_match
> > to the driver; the OF support patch didn't include that part of the code.
> > As such, Ben can't yet apply this to his tree. (Although I note this patch
> > is in Grant's /arm and /test trees, which is probably good enough for now).
> 
> Hmmm, I thought it had been done.  It certainly is ready to go in.  Do
> you want to put together a roll-up patch that includes all the
> required changes and post it again? (although double check linux-next
> first).

When John Bonesio posted the patch to add DT support to i2c-tegra.c, the first
version of the patch was missing the match table chunk. A few days later, an
updated version was posted that added the missing chunk; see:

http://groups.google.com/group/linux.kernel/browse_thread/thread/d2596e8dee819b0f/c8aa04183ea2331e?show_docid=c8aa04183ea2331e

It looks like the first version of the patch has actually been applied to Ben's
next-i2c branch rather than the updated version.

I guess it's simplest if I just post a patch that adds the missing chunk based
on the latest next-i2c tree. I'll go do that.

-- 
nvpublic

