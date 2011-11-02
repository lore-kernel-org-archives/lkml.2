Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab1KBM0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 08:26:45 -0400
Received: from 6.mo3.mail-out.ovh.net ([188.165.43.173]:34224 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752306Ab1KBM0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 08:26:44 -0400
X-Greylist: delayed 19518 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Nov 2011 08:26:44 EDT
Date: Wed, 2 Nov 2011 08:00:42 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robherring2@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH] dt: add empty of_alias_get_id() for non-dt builds
Message-ID: <20111102070042.GA7136@game.jcrosoft.org>
References: <1319706448-1664-1-git-send-email-nicolas.ferre@atmel.com>
 <4EAAABF6.50803@gmail.com>
 <20111029114905.GA22592@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111029114905.GA22592@ponder.secretlab.ca>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 16916083151829904156
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -200
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfedvtddrvdduucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmneculddquddttddm
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -200
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeftddrheekucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmneculddquddttddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:49 Sat 29 Oct     , Grant Likely wrote:
> On Fri, Oct 28, 2011 at 08:19:50AM -0500, Rob Herring wrote:
> > On 10/27/2011 04:07 AM, Nicolas Ferre wrote:
> > > Add function of_alias_get_id() reporting -ENOSYS
> > > for non-dt builds, so that drivers migrating to dt
> > > can save some '#ifdef CONFIG_OF'.
> > > 
> > > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > 
> > Acked-by: Rob Herring <rob.herring@calxeda.com>
> 
> Merged, thanks
> 
> Rob, for stuff like this, please do pick it up into your git tree and
> reply saying that you've done so.  Then I know I can ignore it because
> I'll be receiving a pull req from you in short order.
> 
> Similarly, I reply whenever I pick up a patch, so you'll know if I've
> already delt with it.
this is still missing in the mainline kernel

the at91 ends broken can one of you send a pull with it to Linus

Best Regards,
J.
