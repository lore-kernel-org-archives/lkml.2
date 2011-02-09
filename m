Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab1BIUMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 15:12:54 -0500
Received: from kroah.org ([198.145.64.141]:39469 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab1BIUMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 15:12:53 -0500
Date: Wed, 9 Feb 2011 12:04:34 -0800
From: Greg KH <greg@kroah.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Dan Carpenter <error27@gmail.com>, devel@driverdev.osuosl.org,
        jon.nettleton@gmail.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        cjb@laptop.org
Subject: Re: [PATCH RFC] staging: olpc_dcon: Remove _strtoul() function.
Message-ID: <20110209200434.GA30192@kroah.com>
References: <1297163160-23429-1-git-send-email-marek.belisko@open-nandra.com>
 <20110208112354.GN4384@bicker>
 <20110208094020.44f0fe88@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110208094020.44f0fe88@queued.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 09:40:20AM -0800, Andres Salomon wrote:
> On Tue, 8 Feb 2011 14:23:54 +0300
> Dan Carpenter <error27@gmail.com> wrote:
> 
> > On Tue, Feb 08, 2011 at 12:06:00PM +0100, Marek Belisko wrote:
> > > olpc_dcon driver use self invented _strtoul  function
> > > which make similar check like strict_strtoul just extend
> > > for space checking at last string place. Normally access
> > > to sys file looks echo 1024 > /sys/... so space could be considered
> > > as error character and we could simplify code using just
> > > strict_strtoul function instead self invented.
> > > 
> > 
> > Could you do it on top of the patches that Andres Salomon sent?
> > 
> 
> Actually, I have more pending patches.  I can add this to the patchset
> and send it later.  Greg, please don't merge it now, though.

Ok, I've ignored it for now.
