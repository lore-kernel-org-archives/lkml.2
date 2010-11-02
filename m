Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab0KBPUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 11:20:14 -0400
Received: from kroah.org ([198.145.64.141]:52602 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532Ab0KBPUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 11:20:10 -0400
Date: Tue, 2 Nov 2010 08:20:55 -0700
From: Greg KH <greg@kroah.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Naveen Kumar GADDIPATI <naveen.gaddipati@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCHv1] staging: Synaptics RMI4 touchpad driver support
Message-ID: <20101102152055.GA2104@kroah.com>
References: <1288699725-14405-1-git-send-email-naveen.gaddipati@stericsson.com> <20101102140337.GC9387@kroah.com> <4CD01CD8.3090206@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD01CD8.3090206@stericsson.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 03:14:48PM +0100, Linus Walleij wrote:
> Greg KH wrote:
> 
> >> +Wait for the official upstream synaptics rmi4 clearpad drivers as promised over the past few months
> >> +Merge any device support needed from this driver into it
> >> +Delete this driver
> > 
> > Huh?
> > 
> > Why not just add this driver to the kernel tree instead?  When the
> > "promised" driver then eventually shows up (who is promising it?) then
> > delete the thing.
> 
> Well, Alan (on behalf of Ramesh Agarwal) sent out a very similar
> patch (Titled "Synaptics TM1217 Touchscreen Controller driver")
> the other day, and OTOMH that was after discussions with Synaptics
> where they said they were working on a "real" driver (a rather
> complex RMI4 bus driver) and we believe they will fix that sooner
> or later.
> 
> So, until sooner or later happens we thought we'd keep it in staging.
> 
> If you prefer both Alan and we can probably submit our patches for
> inclusion in the proper place.

Yes, please do that.

> A side effect may be that the Synaptics RMI4 people may have trouble
> to merge their driver into input/ since they may be requested to
> refactor the existing drivers to use it rather than merging new stuff,
> putting some burden on their shoulders.

That's the burden of any developer, especially ones that are slower to
get their code released :)

thanks,

greg k-h
