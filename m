Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab1CFVM3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 16:12:29 -0500
Received: from cantor.suse.de ([195.135.220.2]:52399 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451Ab1CFVM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 16:12:26 -0500
Date: Sun, 6 Mar 2011 22:12:23 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Harry Wei <jiaweiwei.xiyou@gmail.com>, linux@kbdbabel.org,
        romfs@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, greg@kroah.com, akpm@linux-foundation.org
Subject: Re: [PATCH]fix a link in Documentation/filesystem/romfs.txt
In-Reply-To: <alpine.LNX.2.00.1103062207470.19969@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1103062211320.19969@pobox.suse.cz>
References: <20110304115926.GA4104@gmail.com> <20110304093548.a37e0ef9.rdunlap@xenotime.net> <alpine.LNX.2.00.1103062207470.19969@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Mar 2011, Jiri Kosina wrote:

> > > Hello romfs group,
> > > 	 I have posted a patch to fix the reference to
> > > the outdated ftp site (which still serves genromfs-0.5.1) in
> > > Documentation/filesystems/romfs.txt last month,
> > > but nobody has picked it up yet.
> > > 
> > > Does anybody like to forward this?
> > > Thanks, Alexander
> > 
> > Hi Jiri,
> > Do you have this merged somewhere?
> 
> Hi Randy,
> 
> nope, I haven't been CCed and missed it on lkml (obviously :) ). Picked up 
> now, thanks.

Ah, actually yes, it's already in the queue, commit ddf1228695.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
