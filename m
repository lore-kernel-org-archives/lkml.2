Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab1AVAEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 19:04:34 -0500
Received: from kroah.org ([198.145.64.141]:46109 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949Ab1AVAEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 19:04:33 -0500
Date: Fri, 21 Jan 2011 15:54:31 -0800
From: Greg KH <greg@kroah.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Naveen Kumar G <naveen.gaddipati@stericsson.com>,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com
Subject: Re: [PATCH 2/2] staging: synaptics: Implement error hamdling for
 rmi4 touch regulator
Message-ID: <20110121235431.GA23124@kroah.com>
References: <1295605236-3031-1-git-send-email-naveen.gaddipati@stericsson.com>
 <20110121203815.GA25099@kroah.com>
 <20110121233329.GB27943@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110121233329.GB27943@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 03:33:30PM -0800, Dmitry Torokhov wrote:
> On Fri, Jan 21, 2011 at 12:38:15PM -0800, Greg KH wrote:
> > On Fri, Jan 21, 2011 at 03:50:36PM +0530, Naveen Kumar G wrote:
> > > From: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
> > > 
> > > Implement the error handling for regulator in synaptics
> > > rmi4 touch screen
> > > 
> > > Signed-off-by: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
> > 
> > This patch has some fuzz and doesn't apply correctly.  Care to rediff it
> > and resend it?
> > 
> 
> Given that this driver is a [hopefully] dead-end placeholder should we
> even spend time cleaning this up? It would be better if effor was spent
> helping Synaptics folks clean up their generic driver...

I agree, but this looks like a new feature being added.  We also can't
keep people from sending patches in, and if Synaptics never comes
through with their new driver, hey, all the better :)

thanks,

greg k-h
