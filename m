Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124Ab1I2Xj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 19:39:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43400 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757997Ab1I2Xj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 19:39:28 -0400
Date: Thu, 29 Sep 2011 16:39:02 -0700
From: Greg KH <gregkh@suse.de>
To: Doug Ledford <dledford@redhat.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [159/244] ipc/mqueue.c: fix mq_open() return value
Message-ID: <20110929233902.GA5969@suse.de>
References: <20110929190855.GA5381@suse.de>
 <d089f3ec-ccfc-4350-bd11-b8ccadf4ad3a@zmail05.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d089f3ec-ccfc-4350-bd11-b8ccadf4ad3a@zmail05.collab.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 07:31:41PM -0400, Doug Ledford wrote:
> ----- Original Message -----
> > Sorry, I ment Linus's tree, that's where it matters for the stable
> > releases.
> 
> The patch in question hasn't hit Linus' tree yet, but it's queued up
> in Stephen Rothwell's for-next tree.  As I understand it, Andrew's
> tree gets fed into that on a somewhat regular basis, and Andrew took
> my four patches (plus a patchcheck fixup he committed) already.  So, I
> pulled Stephen's for-next, put my patches plus the patchcheck fix on
> top, then wrote a fixup patch that fixes what I saw as being wrong in
> the patch in question.
> 
> > Ok, care to get the patch into Linus's tree and then I can take it
> > into
> > stable?
> 
> I made a new patch that fixes the patch I NAKed.  My entire patch set
> can be applied on top of his now (I was wrong about them conflicting,
> I think there was just enough space for the context not to overlap in
> a way that would conflict as I thought it would).  So, since the
> change isn't life threatening or anything, and can be easily fixed up,
> I'll withdraw my NAK and just submit the additional patch to correct
> it once I get home and have access to a mail program that does
> something besides attachments or mangled text as the only patch
> sending options.
> 
> Now, the question of whether or not you want a patch in -stable that
> hasn't hit Linus' tree yet is up to you...

Sorry, I can't do that, it's against the rules for -stable (see
Documentation/stable_kernel_rules.txt).

Just get your patch into Linus's tree soon, and all should be good,
right?

thanks,

greg k-h
