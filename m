Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab0HALtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 07:49:19 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:59278 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab0HALtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 07:49:17 -0400
Date: Sun, 1 Aug 2010 13:49:15 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Nir Tzachar <nir.tzachar@gmail.com>
Cc: mmarek@suse.cz, rdunlap@xenotime.net, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, trapdoor6@gmail.com,
        justinmattock@gmail.com
Subject: Re: [PATCH] nconfig: add search support
Message-ID: <20100801114915.GA12659@merkur.ravnborg.org>
References: <AANLkTik1p0oK=-msd0a-4wA88Z-Cv29qHVNUYeEETcJD@mail.gmail.com> <1280647233-2578-1-git-send-email-nir.tzachar@gmail.com> <20100801092859.GA12213@merkur.ravnborg.org> <AANLkTimXahVmYCo+UJYDkK_qQxCz0HByBGV9WoJtXWkP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimXahVmYCo+UJYDkK_qQxCz0HByBGV9WoJtXWkP@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sure, but we need to come up with a good description of the behavior
> we desire. As we did not discuss it, I just went ahead and implemented
> a POC.

How about something like this:

In search mode:
- all normal letters / numbers are added to the search criteria

arrow-up/arrow-down move cursor to prev/next match
ESC terminate search mode

All other keys terminate search and take usual action
This include space, arrow-left/right, page-up/down, F*, enter, etc.

	Sam
