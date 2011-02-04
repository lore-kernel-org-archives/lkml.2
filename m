Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab1BDT7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 14:59:48 -0500
Received: from kroah.org ([198.145.64.141]:37328 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470Ab1BDT7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 14:59:07 -0500
Date: Fri, 4 Feb 2011 11:45:21 -0800
From: Greg KH <greg@kroah.com>
To: Davidlohr Bueso <dave@gnu.org>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/2] USB: tools: Add a Makefile
Message-ID: <20110204194521.GA17281@kroah.com>
References: <1296157174.2113.6.camel@offworld>
 <4D42B436.8070901@ru.mvista.com>
 <1296217427.2169.0.camel@offworld>
 <4D42B8B4.40404@ru.mvista.com>
 <1296219097.2169.6.camel@offworld>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296219097.2169.6.camel@offworld>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 09:51:37AM -0300, Davidlohr Bueso wrote:
> On Fri, 2011-01-28 at 15:38 +0300, Sergei Shtylyov wrote:
> > Hello.
> > 
> > On 28-01-2011 15:23, Davidlohr Bueso wrote:
> > 
> > >> On 27-01-2011 22:39, Davidlohr Bueso wrote:
> > 
> > >>> I originally sent this in several months ago, but never got around to correcting the changes, so... here it is.
> > 
> > >>      This remark should follow the --- tear line, to be automatically stripped
> > >> when applying the patch.
> > 
> > > It wasn't meant for the log, that's why it's above the tear line.
> > 
> >     Everything above the tearline gets into the changelog. If it wasn't meant 
> > to, it should be below the tearline, or have to be manually edited out of it.
> > 
> I should have been clearer. What I meant was that the text I didn't want
> in the changelog was above the "From:" (and of course above the ---). I
> didn't know it is supposed to be below the tearline. Thanks for pointing
> this out. 
> If anyone is going to take the patch, do you prefer for me to resend it?

Yes, please redo it, and the first patch in this series, and resend it
so that I can apply them.

thanks,

greg k-h
