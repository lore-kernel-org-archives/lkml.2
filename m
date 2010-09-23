Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab0IWCWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 22:22:47 -0400
Received: from kroah.org ([198.145.64.141]:41857 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596Ab0IWCWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 22:22:46 -0400
Date: Wed, 22 Sep 2010 19:22:56 -0700
From: Greg KH <greg@kroah.com>
To: Tracey Dent <tdent48227@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Staging: rtl8187se: r8180.h: fixed alot of
	checkpatch.pl issues
Message-ID: <20100923022256.GB27057@kroah.com>
References: <1285031982-3870-1-git-send-email-tdent48227@gmail.com> <20100922232458.GB18432@haskell.muteddisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100922232458.GB18432@haskell.muteddisk.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 04:24:58PM -0700, matt mooney wrote:
> On 21:19 Mon 20 Sep     , Tracey Dent wrote:
> > Fixed numerous coding style issues
> > 
> The subject should be more specific as to what the patch does, such as
> "Staging: rtl8187se: r8180.h: whitespace cleanup."
> 
> And the explanation in the commit should also be more specific. There are
> plenty of examples if you look through the log. Greg might except them as is,
> but any future patches should follow the advice mentioned. Next time for a
> patch of this nature remember to CC kernel-janitors too. 

Why the janitor list?  Do you really want that to be copied on every
cleanup patch I get like this?  That would be a _lot_...

thanks,

greg k-h
