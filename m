Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab0IBOaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 10:30:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab0IBOau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:30:50 -0400
Date: Thu, 2 Sep 2010 16:30:48 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephane Chatty <chatty@enac.fr>
Subject: Re: [PATCH] hid: Add a hid quirk for input sync override
In-Reply-To: <4C7E39CC.80402@euromail.se>
Message-ID: <alpine.LNX.2.00.1009021630000.26813@pobox.suse.cz>
References: <1282640084-19217-1-git-send-email-rydberg@euromail.se> <alpine.LNX.2.00.1009011252450.26813@pobox.suse.cz> <4C7E39CC.80402@euromail.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Sep 2010, Henrik Rydberg wrote:

> >> As of lately, HID devices which send per-frame data split over several
> >> HID reports have started to emerge. This patch adds a quirk which
> >> allows the HID driver to take over the input layer synchronization,
> >> and hence the control of the frame boundary.
> >>
> >> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> >> ---
> >> Jiri, Dmitry, Stephane,
> >>
> >> No doubt, this is not a final solution, but it serves the purpose of
> >> being able to make existing drivers functional while a satisfactory
> >> solution is being worked out.
> > 
> > Hi Henrik,
> > 
> > I obviously don't have any major objections to the patch, as it was my 
> > initial idea :)
> 
> 
> Ah! Then all is fine. :-)
> 
> > 
> > I'd like to merge it together with driver which actually uses it though.
> 
> 
> Sounds good. I suppose Stephane wants to have a say regarding the 3m driver
> first, but no rush. What version are you targeting?

2.6.37 looks reasonable if everything it agreed upon in the following 
week(s).

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
