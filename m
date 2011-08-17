Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab1HQSfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 14:35:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54338 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab1HQSft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 14:35:49 -0400
Date: Wed, 17 Aug 2011 13:35:44 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>,
        Henrik Rydberg <rydberg@euromail.se>,
        Chase Douglas <chase.douglas@canonical.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Huang <aaron_huang@emc.com.tw>, JJ Ding <jj_ding@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>
Subject: Re: [PATCH] Input: elantech - Add v3 hardware support
Message-ID: <20110817183544.GB31314@thinkpad-t410>
Mail-Followup-To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Alessandro Rubini <rubini@cvml.unipv.it>,
	Henrik Rydberg <rydberg@euromail.se>,
	Chase Douglas <chase.douglas@canonical.com>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	Aaron Huang <aaron_huang@emc.com.tw>, JJ Ding <jj_ding@emc.com.tw>,
	Eric Piel <E.A.B.Piel@tudelft.nl>
References: <1313589793-31184-1-git-send-email-seth.forshee@canonical.com>
 <20110817173111.GD4877@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110817173111.GD4877@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 10:31:11AM -0700, Dmitry Torokhov wrote:
> Hi Seth,
> 
> On Wed, Aug 17, 2011 at 09:03:13AM -0500, Seth Forshee wrote:
> > Adds basic v3 hardware support for newer devices not currently
> > supported by the driver.
> > 
> > Thanks to Tom Lin <tom_lin@emc.com.tw> and Mark A. Stratman
> > <stratman@gmail.com>, whose work on a previous patch revealed many
> > of the details of the v3 protocol.
> 
> Excellent work, thank you.
> 
> Apparently Elantech is now also interested in supporting ther devices
> on Linux and is preparing some patches adding support for the new
> hardware so it woudl be great if we coordinated efforts. I am CC-ing
> JJ Ding and Aaron Huang...

Sure, I'd be happy to coordinate.

Where does that leave this patch? Do you want to take it now and
integrate improvments from working with Elantech as they come, or hold
off? I'd personally like to see this patch get merged unless there are
objections to it, as it works well and gives us at least some support
for these touchpads right now. It's been tested so far on the following
laptop models:

  Samsung NF210
  Samsung NF310
  Samsung QX410
  Asus X93S

It would certainly be great to get it reviewed by the folks from
Elantech to make sure all the details of the hardware interaction are
correct though.

Thanks,
Seth
