Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab0I1MLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 08:11:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36610 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab0I1MLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 08:11:06 -0400
Date: Tue, 28 Sep 2010 05:07:43 -0700
From: Greg KH <gregkh@suse.de>
To: Raju Rameshwar Uprade <rajsingh@ncra.tifr.res.in>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Regarding USB-to-serial device driver
Message-ID: <20100928120743.GA15807@suse.de>
References: <20100913154843.GA27496@suse.de> <20100914060649.M96376@admin-gateway.ncra.tifr.res.in> <20100914131925.GC375@suse.de> <20100922052107.M44650@admin-gateway.ncra.tifr.res.in> <20100922145607.GB26309@suse.de> <20100923100127.M64470@admin-gateway.ncra.tifr.res.in> <20100923140236.GB31394@suse.de> <20100928091520.M79654@admin-gateway.ncra.tifr.res.in> <20100928113036.GA15024@suse.de> <20100928115204.M46802@admin-gateway.ncra.tifr.res.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100928115204.M46802@admin-gateway.ncra.tifr.res.in>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 05:26:35PM +0530, Raju Rameshwar Uprade wrote:
> 
> > Is this with your patched pl2303 driver, or are you now doing this from
> > userspace?
> 
>  This is patched pl2303 driver.

Then again, sorry, you are on your own here.

> > This looks like your driver, not mine, sorry, you are on your own here.
> > See my previous emails as to why this should be done in userspace and
> > not in the kernel.
> 
> Is it possible to control RTS line from user space.

Yes.

> kindly send me some links, regarding doing the things from userspace like controlling
> RTS line,adding mark and space parity with the data bytes.

There's this cool new site called 'google.com' that you might want to
look into using to find this kind of information :)

Seriously, start at the Serial Programming HOWTO and go from there.

good luck,

greg k-h
