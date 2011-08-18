Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab1HRBpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 21:45:54 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:45874 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab1HRBpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 21:45:51 -0400
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Aug 2011 21:45:51 EDT
From: JJ Ding <jj_ding@emc.com.tw>
To: Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>,
        Henrik Rydberg <rydberg@euromail.se>,
        Chase Douglas <chase.douglas@canonical.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Huang <aaron_huang@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>, Tom Lin <tom_lin@emc.com.tw>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: Re: [PATCH] Input: elantech - Add v3 hardware support
In-Reply-To: <20110817183544.GB31314@thinkpad-t410>
References: <1313589793-31184-1-git-send-email-seth.forshee@canonical.com> <20110817173111.GD4877@core.coreip.homeip.net> <20110817183544.GB31314@thinkpad-t410>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 18 Aug 2011 09:38:04 +0800
Message-ID: <87mxf74hz7.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

Thank you for your work.
I am preparing my patches for community review, and will submit very
soon.
Looking forward to your feedback.

Thanks.

jj

On Wed, 17 Aug 2011 13:35:44 -0500, Seth Forshee <seth.forshee@canonical.com> wrote:
> On Wed, Aug 17, 2011 at 10:31:11AM -0700, Dmitry Torokhov wrote:
> > Hi Seth,
> > 
> > On Wed, Aug 17, 2011 at 09:03:13AM -0500, Seth Forshee wrote:
> > > Adds basic v3 hardware support for newer devices not currently
> > > supported by the driver.
> > > 
> > > Thanks to Tom Lin <tom_lin@emc.com.tw> and Mark A. Stratman
> > > <stratman@gmail.com>, whose work on a previous patch revealed many
> > > of the details of the v3 protocol.
> > 
> > Excellent work, thank you.
> > 
> > Apparently Elantech is now also interested in supporting ther devices
> > on Linux and is preparing some patches adding support for the new
> > hardware so it woudl be great if we coordinated efforts. I am CC-ing
> > JJ Ding and Aaron Huang...
> 
> Sure, I'd be happy to coordinate.
> 
> Where does that leave this patch? Do you want to take it now and
> integrate improvments from working with Elantech as they come, or hold
> off? I'd personally like to see this patch get merged unless there are
> objections to it, as it works well and gives us at least some support
> for these touchpads right now. It's been tested so far on the following
> laptop models:
> 
>   Samsung NF210
>   Samsung NF310
>   Samsung QX410
>   Asus X93S
> 
> It would certainly be great to get it reviewed by the folks from
> Elantech to make sure all the details of the hardware interaction are
> correct though.
> 
> Thanks,
> Seth
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
