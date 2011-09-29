Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab1I2TKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 15:10:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58624 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249Ab1I2TKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 15:10:06 -0400
Date: Thu, 29 Sep 2011 12:08:55 -0700
From: Greg KH <gregkh@suse.de>
To: Doug Ledford <dledford@redhat.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [159/244] ipc/mqueue.c: fix mq_open() return value
Message-ID: <20110929190855.GA5381@suse.de>
References: <20110929175716.GA5815@suse.de>
 <f27ffef8-9ec1-4254-bb26-1f2fdf4366c7@zmail05.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f27ffef8-9ec1-4254-bb26-1f2fdf4366c7@zmail05.collab.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 02:51:51PM -0400, Doug Ledford wrote:
> ----- Original Message -----
> > Um, that's the way this patch is upstream, right?  So perhaps it
> > should
> > be fixed there first and then I can take the fix into -stable?
> 
> Upstream is a bit of a fuzzy statement ;-)  It might be in -next, but
> it's not in Linus' tree or Andrew's -mm tree or else my recent patches
> would have conflicted.

Sorry, I ment Linus's tree, that's where it matters for the stable
releases.

> And in fact, upon further reflection, I think maybe that particular
> test could use being split into two distinct tests.  One for wrapping
> the byte counter, which would return -ENOMEM, and one for exceeding
> RLIMIT_MSGQUEUE which would return -EPERM (not sure if that's right, I
> would have to poke around elsewhere, but it seems a better response
> when you are violating a ulimit than nomem to me anyway).

Ok, care to get the patch into Linus's tree and then I can take it into
stable?

greg k-h
