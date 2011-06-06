Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab1FFSAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:00:54 -0400
Received: from mail.elliptictech.com ([209.217.122.41]:34085 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1FFSAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:00:53 -0400
Date: Mon, 6 Jun 2011 14:00:49 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Melchior FRANZ <melchior.franz@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Keith Packard <keithp@keithp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression: Borked display on second output with Intel G45 in
 3.0-rc2
Message-ID: <20110606180049.GA2777@elliptictech.com>
References: <20110606171253.GA2925@elliptictech.com>
 <201106061920.07144@rk-nord.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106061920.07144@rk-nord.at>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-06 19:20 +0200, Melchior FRANZ wrote:
> * Nick Bowler -- Monday 06 June 2011:
> > After upgrading to 3.0-rc2, my second display is no longer working
> > correctly on a desktop with an Intel G45 graphics chip.
> [...]
> > What I do know is that the problem was originally introduced by
> > 49183b2818de ("drm/i915: Only enable the plane after setting the fb
> > base (pre-ILK)").  It was subsequently fixed by 982b2035d9d7 ("Revert
> > "drm/i915: Only enable the plane after setting the fb base (pre-ILK)"").
> > The problem was reintroduced by 98b98d316349 ("Merge branch 'drm-core-next'
> > of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6").
> 
> That's apparently the bug that I've submitted a patch for on 2011/5/31:
> https://lkml.org/lkml/2011/5/31/393
> I assume/hope it's still in someone's queue.

Yup, that fixes it right up, thanks.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
