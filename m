Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab0IHAhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 20:37:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53912 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755652Ab0IHAhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 20:37:48 -0400
Date: Tue, 7 Sep 2010 17:34:24 -0700
From: Greg KH <gregkh@suse.de>
To: Mihai Don??u <mihai.dontu@gmail.com>
Cc: "Gadiyar, Anand" <gadiyar@ti.com>, Maxim Osipov <maxim.osipov@gmail.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: Fix kernel oops with g_ether and Windows
Message-ID: <20100908003424.GA27719@suse.de>
References: <AANLkTinKBYzMwxEJarwN_HmKAORqJ7oiauj5JuXCo+rm@mail.gmail.com> <5A47E75E594F054BAF48C5E4FC4B92AB03293269CD@dbde02.ent.ti.com> <20100907212915.GB6798@suse.de> <201009080254.03070.mihai.dontu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009080254.03070.mihai.dontu@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 02:54:02AM +0300, Mihai Don??u wrote:
> On Wednesday 08 September 2010 00:29:15 Greg KH wrote:
> > On Tue, Sep 07, 2010 at 04:18:23PM +0530, Gadiyar, Anand wrote:
> > > Since Greg has already sent a pull request, I won't touch the file
> > > now; maybe a trivial patch later on to fix up the coding style.
> > 
> > That would be fine to have, I'd gladly accept it.
> 
> Would something like the following do? It's against:
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6.git
> 
> Corrected the coding style.

Looks good, thanks, I'll go queue it up.

greg k-h
