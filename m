Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628Ab1BYSrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:47:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56435 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932436Ab1BYSrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:47:10 -0500
Date: Fri, 25 Feb 2011 10:44:28 -0800
From: Greg KH <gregkh@suse.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt: add a match table pointer to struct device
Message-ID: <20110225184428.GA2280@suse.de>
References: <20110223025233.25131.47193.stgit@localhost6.localdomain6>
 <AANLkTikauP8+PgFyicdSQzJ19ZvqpV=3ZnRTjSvY78qc@mail.gmail.com>
 <20110225163547.GC8523@suse.de>
 <AANLkTik1fzJw11mKSVu4B2yrGZAju59uNmHjjGSgVcGY@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik1fzJw11mKSVu4B2yrGZAju59uNmHjjGSgVcGY@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 10:34:05AM -0700, Grant Likely wrote:
> On Fri, Feb 25, 2011 at 9:35 AM, Greg KH <gregkh@suse.de> wrote:
> > On Fri, Feb 25, 2011 at 08:46:52AM -0700, Grant Likely wrote:
> >> Greg, any thoughts on this change?  I'd like to take it via my tree so
> >> I can finally dump the last vestiges of of_platform_bus_type.
> >
> > Sorry, I didn't realize you just wanted my review, and not me to take it
> > directly.
> 
> Heh, I wasn't very clear about that.  Oops,
> 
> > If you want to take it, that's great, no objection from me, feel free to
> > add:
> >        Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> > to it.
> 
> Thanks.  Yes I definitely want to take it because I've got a pile of
> patches that depend on it.
> 
> > What about the other patch you sent me, do you want me to take that, or
> > will you?
> 
> Which one is that?  The relaxation of .name checking on of_serial?
> Yes, you can take that one, but hold off for the moment.  Looking at
> it now I realize that I forgot to cc some folks that should ack it, so
> I'm going to repost.

Oops, I just took it :(

thanks,

greg k-h
