Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab0DNV5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 17:57:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:43290 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab0DNV5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 17:57:08 -0400
Date: Wed, 14 Apr 2010 23:57:04 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: add HP Compaq 2710p to 'noloop' table
In-Reply-To: <20100414160429.GC2450@core.coreip.homeip.net>
Message-ID: <alpine.LNX.2.00.1004142354330.8345@pobox.suse.cz>
References: <alpine.LNX.2.00.1004141409450.8345@pobox.suse.cz> <20100414160429.GC2450@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010, Dmitry Torokhov wrote:

> > Add HP Compaq 2710p to 'noloop' table. Otherwsie this machine is reported 
> > to not report properly to AUX_LOOP command time-to-time, causing 
> > non-working keyboard due to messed up i8042.
> > 
> 
> What is the chassis type for the box in DMI? I am curious why it isn't
> caought up by the generic "portable" test...

Hmm, you are right, I completely forgot that we are now completely 
bypassing AUX IRQ delivery on Portable/Laptop/(Sub-)Notebook chasis types.

I was going through my older patchqueue and flushing it, and this one 
slipped through, as it is apparently not necessary for current mainline 
(the machine in question has chasis type "Notebook"), but only for older 
kernels.

Sorry for the fuss.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
