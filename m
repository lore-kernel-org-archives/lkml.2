Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab1GTQlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 12:41:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47694 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab1GTQlV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 12:41:21 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Jon Povey <jon.povey@racelogic.co.uk>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hilman, Kevin" <khilman@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 20 Jul 2011 22:10:57 +0530
Subject: RE: [PATCH] davinci: fix DM365 EVM video input mux bits
Thread-Topic: [PATCH] davinci: fix DM365 EVM video input mux bits
Thread-Index: AcxGAnAUt5Cm3zLBTGOBhKxT11KfBgA9/zIg
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024DC70E2A@dbde02.ent.ti.com>
References: <1311046211-2849-1-git-send-email-jon.povey@racelogic.co.uk>
 <B85A65D85D7EB246BE421B3FB0FBB593024DBDC68A@dbde02.ent.ti.com>
 <20110719105532.GF26574@n2100.arm.linux.org.uk>
In-Reply-To: <20110719105532.GF26574@n2100.arm.linux.org.uk>
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

Hi Russell,

On Tue, Jul 19, 2011 at 16:25:32, Russell King - ARM Linux wrote:
> On Tue, Jul 19, 2011 at 02:26:50PM +0530, Nori, Sekhar wrote:
> > Since this part of the code hasn't changed since it
> > was written, this is a good candidate for stable
> > kernel series. You can just add:
> > 
> > Cc: stable@kernel.org
> 
> Be careful when doing that - if you have git mail the patches out for
> review, and it picks that up, it'll send it to the stable team as well.
> The stable team will then complain "that's not how to submit patches
> to them".
> 
> So, while you can add "Cc: stable@kernel.org" to the patch, its best
> to only add that just before you publish the commit after review, but
> before merging.

But its very tough to guess what the last version
ready for merging will be. Review comments can come
at any stage.

Would adding "Cc: stable@kernel.org" to the commit text
but taking care to not actually send mail to stable@kernel.org
help? The stable_kernel_rules.txt document seems to suggest
this is an acceptable way:

"
- To have the patch automatically included in the stable tree, add the tag
     Cc: stable@kernel.org
   in the sign-off area. Once the patch is merged it will be applied to
   the stable tree without anything else needing to be done by the author
   or subsystem maintainer.
"

Thanks,
Sekhar
