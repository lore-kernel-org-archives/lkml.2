Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab1F1WPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:15:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47110 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab1F1WPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:15:30 -0400
Date: Wed, 29 Jun 2011 00:15:29 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/29] gma500: Ensure the frame buffer has a linear
 virtual mapping
In-Reply-To: <alpine.LNX.2.00.1106290003060.11049@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1106290013350.11049@pobox.suse.cz>
References: <20110616160104.6039.44019.stgit@localhost.localdomain> <20110616160642.6039.31781.stgit@localhost.localdomain> <20110628211859.GA23217@kroah.com> <20110628230245.4cec6958@lxorguk.ukuu.org.uk> <alpine.LNX.2.00.1106290003060.11049@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jun 2011, Jiri Kosina wrote:

> > Can you drop the bits you have merged and I'll send you a new set (which
> > will instead break the stuff Jiri has in his tree and he can fix it up)
[ ... snip ... ]
> I will drop the staging bits, sorry again for missing those in the bulk.

Or just let me know whatever you prefer (both now and in the longer 
term as well).

I can either drop the gma500 bits I have queued now (and stop applying 
anything touching it, hard rule), or you rebasing on top of Greg's staging 
tree instead of linux-next (and I sorting out the merge conflict later).

> I am still wondering how come that this is causing trouble to anyone 
> though -- is anyone really developing real code on top of linux-next 
> (which should be there to cross-check merge problems between subsystems 
> and test functionality) instead of particular subsystem tree?

-- 
Jiri Kosina
SUSE Labs
