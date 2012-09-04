Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab2IDVlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 17:41:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52654 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab2IDVlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 17:41:00 -0400
Date: Tue, 4 Sep 2012 14:38:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>, sjenning@linux.vnet.ibm.com,
        minchan@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        devel@linuxdriverproject.org, ngupta@vflare.org
Subject: Re: [PATCH 0/3] staging: ramster: move to new zcache2 code base
Message-ID: <20120904213827.GA12394@kroah.com>
References: <1346366764-31717-1-git-send-email-dan.magenheimer@oracle.com>
 <20120831000020.GA14628@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120831000020.GA14628@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 08:00:20PM -0400, Konrad Rzeszutek Wilk wrote:
> On Thu, Aug 30, 2012 at 03:46:01PM -0700, Dan Magenheimer wrote:
> > Hi Greg --
> > 
> > gregkh> If you feel that the existing code needs to be dropped
> > gregkh> and replaced with a totally new version, that's fine with
> > gregkh> me.  It's forward progress, which is all that I ask for. 
> > (http://lkml.indiana.edu/hypermail/linux/kernel/1208.0/02240.html,
> > in reference to zcache, assuming applies to ramster as well)
> > 
> > Please apply for staging-next for the 3.7 window to move ramster forward.
> > Since AFAICT there have been no patches or contributions from others to
> > drivers/staging/ramster since it was merged, this totally new version
> > of ramster should not run afoul and the patches should apply to
> > 3.5 or 3.6-rcN.
> > 
> > Thanks,
> > Dan
> > 
> > When ramster was merged into staging at 3.4, it used a "temporarily" forked
> > version of zcache.  Code was proposed to merge zcache and ramster into
> > a new common redesigned codebase which both resolves various serious design
> > flaws and eliminates all code duplication between zcache and ramster, with
> > the result to replace "zcache".  Sadly, that proposal was blocked, so the
> > zcache (and tmem) code in drivers/staging/zcache and the zcache (and tmem)
> > code in drivers/staging/ramster continue to be different.
> 
> Right. They will diverge for now.

Konrad, can I get your Acked-by: for this series?  I need that before I
can apply it.

thanks,

greg k-h
