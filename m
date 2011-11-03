Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304Ab1KCMkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 08:40:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49330 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933120Ab1KCMkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 08:40:17 -0400
Date: Thu, 3 Nov 2011 05:18:20 -0700
From: Greg KH <gregkh@suse.de>
To: Sven Joachim <svenjoac@gmx.de>
Cc: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [068/107] Update email address for stable patch submission
Message-ID: <20111103121820.GB7102@suse.de>
References: <20111102221600.GA26650@kroah.com>
 <20111102221456.335891562@clark.kroah.org>
 <1320307257@msgid.manchmal.in-ulm.de>
 <87k47hd34q.fsf@turtle.gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87k47hd34q.fsf@turtle.gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 09:25:09AM +0100, Sven Joachim wrote:
> Am 03.11.2011 um 09:08 schrieb Christoph Biedl:
> 
> > Greg KH wrote...
> >
> > (...)
> >
> > Just out of curiosity:
> >
> >>   - Send the patch, after verifying that it follows the above rules, to
> >> -   stable@vger.kernel.org.
> >> +   stable@vger.kernel.org.
> >>   - The sender will receive an ACK when the patch has been accepted into the
> >
> >>     other developers and by the relevant subsystem maintainer.
> >> - - If the stable@vger.kernel.org address is added to a patch, when it goes into
> >> + - If the stable@vger.kernel.org address is added to a patch, when it goes into
> >>     Linus's tree it will automatically be emailed to the stable team.
> >
> > Whatever you used to create the patches, why did these hunks come into
> > existence?
> 
> The original lines should have had the stable@kernel.org email address,
> looks like Greg's scripts eagerly replaced those with the new address…

Ugh, yes, that was due to me running a script on the emails to keep any
old stable@kernel.org address out of them when I sent them out.  The
original patch is fine, thanks for checking.

greg k-h
