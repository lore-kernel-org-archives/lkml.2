Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab1CQSHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 14:07:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37085 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab1CQSHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 14:07:33 -0400
Date: Thu, 17 Mar 2011 12:07:28 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Ed W <lists@wildgooses.com>
Cc: Andres Salomon <dilinger@queued.net>, rpurdie@rpsys.net,
        linux-geode@lists.infradead.org, const@mimas.ru,
        linux-kernel@vger.kernel.org
Subject: Re: Feedback please: [PATCH] leds: New PCEngines Alix LED driver
 using gpio interface
Message-ID: <20110317180728.GK9597@angua.secretlab.ca>
References: <4D81D7FD.1040602@wildgooses.com>
 <20110317084328.41831b4c@debxo>
 <4D823F19.4070700@wildgooses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D823F19.4070700@wildgooses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 05:04:25PM +0000, Ed W wrote:
> Hi Andres
> 
> Thanks for your feedback!
> 
> >> Additionally it relies on parts of the patch: 7f131cf3ed
> >> by: Daniel Mack <daniel@caiaq.de> to perform detection of the Alix
> >> board
> 
> ..
> >> - * Copyright (C) 2008 Constantin Baranov <const@mimas.ru>
> > 
> > This copyright line should not be removed, so long as parts of the
> > original driver (such as alix_present) remain.
> 
> Thanks for guidance here.
> 
> Can I ask for further thought on this - there is very close to zero
> original driver present, and although I had better do some more diffs to
> be sure, I think you would see the only common code was the #includes, a
> "force" param and a few other { }s?
> 
> I did deliberately reuse the "alix_present" function, but this appears
> to be written by Daniel Mack and contributed in patch: 7f131cf3ed -
> however, Daniel is not listed in the current copyright statement on the
> module (I did copy him and Constantin in on this patch so that either
> might object?).  Also I have tried to show this code attribution in the
> commit statement?
> 
> I have also noted in the code that this is based on leds-net5501.c - is
> this a sufficient and normal attribution?
> 
> Can someone offer a final "ruling" as to how I should state the
> copyright line given that the code was written by taking the
> leds-net5501.c skeleton and approximately applying the commit
> 7f131cf3ed, to give the current code?

Use common sense.  It is always safe to leave copyright notices in
place, but if it really does look like the old stuff is gone then go
ahead and drop it.

Same goes when you clone a driver.  The original copyrights should not
be stripped off unless there really is nothing left.

g.

