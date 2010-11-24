Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab0KXQa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 11:30:57 -0500
Received: from cantor.suse.de ([195.135.220.2]:45498 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367Ab0KXQa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 11:30:56 -0500
Date: Wed, 24 Nov 2010 17:30:53 +0100
From: Jan Kara <jack@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] quota: Use %pV and __attribute__((format (printf in
 __quota_error and fix fallout
Message-ID: <20101124163053.GT6113@quack.suse.cz>
References: <1290566994.11971.26.camel@Joe-Laptop>
 <20101124125029.GO6113@quack.suse.cz>
 <1290610877.11971.59.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290610877.11971.59.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 24-11-10 07:01:17, Joe Perches wrote:
> On Wed, 2010-11-24 at 13:50 +0100, Jan Kara wrote:
> > On Tue 23-11-10 18:49:54, Joe Perches wrote:
> > > Use %pV in __quota_error so a single printk can not be
> > > interleaved with other logging messages.
> > > Add __attribute__((format (printf, 3, 4))) so format
> > > and arguments can be verified by compiler.
> > > Make sure printk formats and arguments match.
> > > 
> > > Block # needed a pointer dereference.
> >   I already had a similar patch from you in my tree. So I've replaced it.
> 
> Perhaps you can get your tree into linux-next.
> 
> I believe you only have to send a request to
> Stephen Rothwell (cc'd).
  It's there but I didn't push the for_next branch. I'll do that as soon
as I'm able to finish some testing on it...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
