Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab0JDRvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 13:51:33 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:34352 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755031Ab0JDRvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 13:51:31 -0400
Date: Mon, 4 Oct 2010 19:51:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [linux-pm] [PATCH 08/23] Hibernation: Generic extents support.
Message-ID: <20101004175122.GB1518@ucw.cz>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
 <1285566238-10966-9-git-send-email-nigel@tuxonice.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285566238-10966-9-git-send-email-nigel@tuxonice.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Separate out the extent storage and manipulation into a separate
> file and make them more generic, so we can also use extents for
> recording what sectors are used and (later) support multiple
> storage devices more easily.
> 
> Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>

> @@ -0,0 +1,125 @@
> +/*
> + * linux/kernel/power/extents.c
> + *
> + * This file provides functions for storing and using a series of
> + * extents.
> + *
> + * Copyright (C) 1998,2001-2005 Pavel Machek <pavel@suse.cz>

That address is no longer valid :-(. Jiri Kosina should already have
patches to remove it elsewhere in the tree.


> +/**
> + *	free_all_swap_pages - free swap pages allocated for saving image data.
> + *	It also frees the extents used to register which swap entres had been
> + *	allocated.
> + */
> +
> +void hib_extents_clear(struct hib_extent_state *pos)

Comment does not match function.



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
