Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762254Ab2FVQsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 12:48:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64063 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654Ab2FVQss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 12:48:48 -0400
Date: Fri, 22 Jun 2012 09:48:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Touko Korpela <touko.korpela@iki.fi>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH] dm thin: reinstate missing mempool_free in
 cell_release_singleton
Message-ID: <20120622164844.GB6896@kroah.com>
References: <20120622151650.GA5785@kroah.com>
 <20120622162127.GA19624@lisko>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120622162127.GA19624@lisko>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 07:21:27PM +0300, Touko Korpela wrote:
> Greg KH wrote:
> > On Fri, Jun 22, 2012 at 10:59:48AM -0400, Mike Snitzer wrote:
> > > Hi Greg,
> > > 
> > > 3.3-stable pulled in upstream commit
> > > 6f94a4c45a6f744383f9f695dde019998db3df55 (dm thin: fix stacked bi_next
> > > usage)
> > > 
> > > But later in the 3.4 development window it was determined that that
> > > commit introduced a significant leak.  The following upstream commit
> > > fixes it (but unfortunately didn't cc: stable).
> >
> > 3.3 is end-of-life, so there's not much I can do with the 3.3-stable
> > tree anymore, sorry.  If there's any other tree I should apply this to
> > that is active (i.e. 3.0 or 3.4), please let me know.
> 
> Looks like you forgot 3.2 that is affected (since 3.2.14).

I don't maintain 3.2 :)
