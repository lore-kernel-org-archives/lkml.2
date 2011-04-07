Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab1DGVpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 17:45:00 -0400
Received: from chipmunk.wormnet.eu ([195.195.131.226]:39694 "EHLO
	chipmunk.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab1DGVpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 17:45:00 -0400
Date: Thu, 7 Apr 2011 22:44:57 +0100
From: Alexander Clouter <alex@digriz.org.uk>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: Differentiate SheevaPlugs and DockStars on
 the basis of the memory size.
Message-ID: <20110407214457.GH26616@chipmunk>
References: <1302122121-3652-1-git-send-email-holler@ahsoftware.de>
 <1302122121-3652-2-git-send-email-holler@ahsoftware.de>
 <alpine.LFD.2.00.1104061739100.28032@xanadu.home>
 <4D9CED15.2010806@ahsoftware.de>
 <alpine.LFD.2.00.1104061850410.28032@xanadu.home>
 <4D9CF5B3.9020007@ahsoftware.de>
 <toa078-0do.ln1@chipmunk.wormnet.eu>
 <4D9E2D1C.7070102@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9E2D1C.7070102@ahsoftware.de>
Organization: diGriz
X-URL: http://www.digriz.org.uk/
X-JabberID: alex@digriz.org.uk
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexander Holler <holler@ahsoftware.de> [2011-04-07 23:31:08+0200]:
>
> Requiring a machine ID and the needed stuff to handle that for a
> board which just is using two GPIOs different than another board is
> why the ARM tree exploded. And requiring a machine ID just to follow
> the rule that a machine ID is much better than some pretty unique hw
> feature is in my humble opinion senseless and that the resulting code
> is more readable and better to maintain is a myth.
> 
It's something that most people agree with you on too.  However, I am 
guessing it's around as no one else *at the time* of it's conception 
could think of a better way.

Now this is why there is a lot of work being done on device-tree.

> Sorry that I wanted to help there. Will not try it again.
> 
Yeah, as obviously no tries to help anyone improve around here:

http://groups.google.com/group/openrd/browse_frm/thread/7ba48f2d7916a88f/2b89c877c4f39098?tvc=1&fwc=1
http://lists.infradead.org/pipermail/linux-arm-kernel/2010-August/022855.html
http://lists.infradead.org/pipermail/linux-arm-kernel/2010-August/024072.html

http://git.kernel.org/?p=linux/kernel/git/nico/orion.git;a=commit;h=f2ac38dc

Regards

-- 
Alexander Clouter
.sigmonster says: Graduate life: It's not just a job.  It's an indenture.
