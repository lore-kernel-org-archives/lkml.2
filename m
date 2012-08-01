Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab2HAKmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 06:42:00 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:5594 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab2HAKl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 06:41:59 -0400
Date: Wed, 1 Aug 2012 12:41:45 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        LKML <linux-kernel@vger.kernel.org>, Peter Tyser <ptyser@xes-inc.com>,
        Aaron Sierra <asierra@xes-inc.com>
Subject: Re: [PATCH] gpio-ich: Share ownership of GPIO groups
Message-ID: <20120801124145.66db90db@endymion.delvare>
In-Reply-To: <20120801101646.GG16859@sortiz-mobl>
References: <20120723173415.5b80b28b@endymion.delvare>
	<20120801111359.6839bec7@endymion.delvare>
	<20120801101646.GG16859@sortiz-mobl>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2012 12:16:46 +0200, Samuel Ortiz wrote:
> On Wed, Aug 01, 2012 at 11:13:59AM +0200, Jean Delvare wrote:
> > Grant, Samuel, Linus (sorry for not including you on original
> > submission), any comment on this? I suppose it's too late for 3.6 but
> > can this be scheduled to be integrated in 3.7?
>
> I was planning to look at this one and queue it for 3.7 as I'll be working on
> my for-next branch once rc1 is tagged.
> As you said, this is not the nicest code ever, so I may have a few comments.
> No time for that right now though.

Great, thank you.

-- 
Jean Delvare
