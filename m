Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab1BYFrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 00:47:45 -0500
Received: from kroah.org ([198.145.64.141]:43660 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab1BYFro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 00:47:44 -0500
Date: Thu, 24 Feb 2011 21:48:38 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>
Subject: Re: linux-next: manual merge of the tty tree with Linus' tree
Message-ID: <20110225054838.GA12619@kroah.com>
References: <20110224163439.05352f9b.sfr@canb.auug.org.au>
 <20110224193947.GA15044@kroah.com>
 <20110225161124.665ac4e9.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225161124.665ac4e9.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 04:11:24PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Thu, 24 Feb 2011 11:39:47 -0800 Greg KH <greg@kroah.com> wrote:
> >
> > Thanks, I've merge 2.6.38-rc6 into tty-next so this, and another merge
> > issue, should now be resolved.
> 
> Thanks.  The tree still has its build failure, though.

Yes, sorry, will fix that tomorrow.

greg k-h
