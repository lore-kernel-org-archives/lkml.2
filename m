Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab2CMEjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 00:39:35 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60428 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab2CMEje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 00:39:34 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: RE: [PATCH 1/2] gpio/davinci: fix oops on unbanked gpio irq request
To: "Nori, Sekhar" <nsekhar@ti.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
In-Reply-To: <DF0F476B391FA8409C78302C7BA518B6317F2D28@DBDE01.ent.ti.com>
References: <1331469972-2638-1-git-send-email-nsekhar@ti.com> <1331469972-2638-2-git-send-email-nsekhar@ti.com> <20120312175135.2BDB53E07B0@localhost> <DF0F476B391FA8409C78302C7BA518B6317F2D28@DBDE01.ent.ti.com>
Date: Mon, 12 Mar 2012 22:39:30 -0600
Message-Id: <20120313043930.6E2EE3E0536@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2012 18:54:53 +0000, "Nori, Sekhar" <nsekhar@ti.com> wrote:
> Hi Grant,
> 
> On Mon, Mar 12, 2012 at 23:21:35, Grant Likely wrote:
> > On Sun, 11 Mar 2012 18:16:11 +0530, Sekhar Nori <nsekhar@ti.com> wrote:
> > > Unbanked GPIO irq setup code was overwriting chip_data leading
> > > to the following oops on request_irq()
> > > 
> > > Unable to handle kernel paging request at virtual address febfffff
> > [...]
> > > Fix the issue.
> > 
> > Applied, but for next time "Fix the issue" isn't the most helpful commit text.
> > Please describe *how* you fixed the issue so that future commit readers have
> > more clues as to what this patch is doing.
> 
> Thanks for the feedback and noted for future. If it's not too much trouble, 
> can you change the last line in commit message to:
> 
> Fix the issue by making unbanked GPIO code not overwrite chip_data because 
> generic irq chip code uses it for its data structures. Instead use 
> handler_data to pass around GPIO controller information.

I've already pushed it out, so I cannot rebase it, but thanks for
taking me seriously.  :-D

g.

