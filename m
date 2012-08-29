Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab2H2RSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 13:18:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36576 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606Ab2H2RSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 13:18:52 -0400
Date: Wed, 29 Aug 2012 10:18:41 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] HID: multitouch: Remove the redundant touch state
In-Reply-To: <CAN+gG=Gwe5_UBsgp5Vk+5dVEFyC4wwUG2ba=P8QfRwJ6veNm4g@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1208291017290.22447@pobox.suse.cz>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se> <1344807757-2217-20-git-send-email-rydberg@euromail.se> <CAN+gG=F6hhOxU--mF2v3sCTzFLHqd6vK5JqcvvDXigss7EkPHQ@mail.gmail.com> <20120822205832.GA18102@polaris.bitmath.org>
 <alpine.LNX.2.00.1208281525060.22447@pobox.suse.cz> <CAN+gG=Gwe5_UBsgp5Vk+5dVEFyC4wwUG2ba=P8QfRwJ6veNm4g@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Aug 2012, Benjamin Tissoires wrote:

> >> With the input_mt_sync_frame() function in place, there is no longer
> >> any need to keep the full touch state in the driver. This patch
> >> removes the slot state and replaces the lookup code with the input-mt
> >> equivalent. The initialization code is moved to mt_input_configured(),
> >> to make sure the full HID report has been seen.
> >>
> >> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> >> ---
> >> Hi Benjamin,
> >>
> >> Maybe this patch works better? It has received limited testing so far.
> >
> > What is the status of this patch please? Henrik, Benjamin?
> 
> Well, Henrik submitted a new release a few days ago (including this version).
> I just didn't found the time to test the whole thing on our different devices.
> It's now on the top of my TODO list.

Ah, I have missed the fact that this one is also part of Henrik's series, 
sorry for the noise.

I haven't unfortunately reviewed the series yet due to kernel summit & 
related events, but I'll get to it shortly.

Thanks,

-- 
Jiri Kosina
SUSE Labs
