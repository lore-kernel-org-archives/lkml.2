Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab0DDN4e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 09:56:34 -0400
Received: from londo.lunn.ch ([80.238.139.98]:45759 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754251Ab0DDN41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 09:56:27 -0400
Date: Sun, 4 Apr 2010 15:56:21 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: The list for a Better Approach To Mobile Ad-hoc
	 Networking <b.a.t.m.a.n@lists.open-mesh.org>
Cc: Sven Eckelmann <sven.eckelmann@gmx.de>, devel@driverdev.osuosl.org,
       gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [B.A.T.M.A.N.] [PATCH 4/4] Staging: batman-adv: fix whitespace
 style issues
Message-ID: <20100404135621.GA16351@lunn.ch>
References: <1270341625-28764-1-git-send-email-luisbg@ubuntu.com>
 <201004040312.28481.sven.eckelmann@gmx.de>
 <p2x506b70dc1004031845p81705070o325d93f839c80e9a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p2x506b70dc1004031845p81705070o325d93f839c80e9a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry about the conflict, thanks for redoing the changes. Where can I
> find the current and development branches? I want to avoid doing this
> mistake again in the future. Specially since I'm planning on doing
> some janitorial work on Staging for a while if it's OK with you guys.
> I see it as nice experience and practice while learning and getting
> ready for more valuable contributions :)

Sven has told you about how batman uses different repositories. You
can find some more information at:

http://www.open-mesh.org/wiki/UsingBatmanGit

When working on other staging drivers i suggest you work on either the
linux-next tree, or contact the driver maintainers and ask if they
have there own development tree. Staging drivers tend to be fast
moving. They change a lot. What is in the current release kernel,
which is effectively 3 months old, can be very different to the latest
development version. I've received many patches to things we have
fixed months ago and are either waiting in linux-next for the next
kernel release, or our in or development tree. I'm sure the same
applies to other drivers in staging.

Another option for interesting work to get involved in the kernel is
to ask GregKH if there is a staging driver which is not being actively
worked on. Some drivers just get dumped there and nobody spends the
time and effort needed to get them merged. After a while they get
thrown out of the staging. You could adopt such a driver, get hold of
the hardware and do the work needed to get it out of staging and into
the main tree.

    Andrew
