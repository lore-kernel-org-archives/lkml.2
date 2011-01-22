Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab1AVAOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 19:14:31 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47741 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938Ab1AVAOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 19:14:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Bc9wnoL4GP1TB8UIKVFFzewgBcdM/3mKRp/qjdAoa9cbMcJGT9hbhU97+Lgdr3QDq/
         DF46gkR1l3h9GY+bycACiIWpvNq+tFFbupP2pZLRXm5Q56A7CCgEIN0/2hMvWDu9oDd1
         TU1DHLCW00MQod2dIabybandt268+g3+NWVfw=
Date: Fri, 21 Jan 2011 16:14:24 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Naveen Kumar G <naveen.gaddipati@stericsson.com>,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com
Subject: Re: [PATCH 2/2] staging: synaptics: Implement error hamdling for
 rmi4 touch regulator
Message-ID: <20110122001423.GD27943@core.coreip.homeip.net>
References: <1295605236-3031-1-git-send-email-naveen.gaddipati@stericsson.com>
 <20110121203815.GA25099@kroah.com>
 <20110121233329.GB27943@core.coreip.homeip.net>
 <20110121235431.GA23124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110121235431.GA23124@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 03:54:31PM -0800, Greg KH wrote:
> On Fri, Jan 21, 2011 at 03:33:30PM -0800, Dmitry Torokhov wrote:
> > On Fri, Jan 21, 2011 at 12:38:15PM -0800, Greg KH wrote:
> > > On Fri, Jan 21, 2011 at 03:50:36PM +0530, Naveen Kumar G wrote:
> > > > From: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
> > > > 
> > > > Implement the error handling for regulator in synaptics
> > > > rmi4 touch screen
> > > > 
> > > > Signed-off-by: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
> > > 
> > > This patch has some fuzz and doesn't apply correctly.  Care to rediff it
> > > and resend it?
> > > 
> > 
> > Given that this driver is a [hopefully] dead-end placeholder should we
> > even spend time cleaning this up? It would be better if effor was spent
> > helping Synaptics folks clean up their generic driver...
> 
> I agree, but this looks like a new feature being added.  We also can't
> keep people from sending patches in, and if Synaptics never comes
> through with their new driver, hey, all the better :)
> 

They just posted an update (rework to use our driver model) a few days
ago. If they weren't working on their driver I'd agree wholeheartedly
with improving this driver.

-- 
Dmitry
