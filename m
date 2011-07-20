Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab1GTQsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 12:48:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56384 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab1GTQsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 12:48:35 -0400
Date: Wed, 20 Jul 2011 17:48:07 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Nori, Sekhar" <nsekhar@ti.com>
Cc: Jon Povey <jon.povey@racelogic.co.uk>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hilman, Kevin" <khilman@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] davinci: fix DM365 EVM video input mux bits
Message-ID: <20110720164807.GA20310@n2100.arm.linux.org.uk>
References: <1311046211-2849-1-git-send-email-jon.povey@racelogic.co.uk> <B85A65D85D7EB246BE421B3FB0FBB593024DBDC68A@dbde02.ent.ti.com> <20110719105532.GF26574@n2100.arm.linux.org.uk> <B85A65D85D7EB246BE421B3FB0FBB593024DC70E2A@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024DC70E2A@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 10:10:57PM +0530, Nori, Sekhar wrote:
> Hi Russell,
> 
> On Tue, Jul 19, 2011 at 16:25:32, Russell King - ARM Linux wrote:
> > On Tue, Jul 19, 2011 at 02:26:50PM +0530, Nori, Sekhar wrote:
> > > Since this part of the code hasn't changed since it
> > > was written, this is a good candidate for stable
> > > kernel series. You can just add:
> > > 
> > > Cc: stable@kernel.org
> > 
> > Be careful when doing that - if you have git mail the patches out for
> > review, and it picks that up, it'll send it to the stable team as well.
> > The stable team will then complain "that's not how to submit patches
> > to them".
> > 
> > So, while you can add "Cc: stable@kernel.org" to the patch, its best
> > to only add that just before you publish the commit after review, but
> > before merging.
> 
> But its very tough to guess what the last version
> ready for merging will be. Review comments can come
> at any stage.
> 
> Would adding "Cc: stable@kernel.org" to the commit text
> but taking care to not actually send mail to stable@kernel.org
> help? The stable_kernel_rules.txt document seems to suggest
> this is an acceptable way:

Correct.
