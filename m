Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab0KLUC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 15:02:27 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39413 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab0KLUCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 15:02:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fE7CGUpUgI3qJS1rUQ25LE0Pr0ZWCe7/9ZlsOh5GranE5xBcrHSiqITSpt5HMLAlQA
         FE2WPEIR72L5VTj/wySxyf4RqIsK879CEes58+/HE7FZPDUVBIjSVUIaFrgcU7jE22xK
         +lh4c0N/nGEjzU48/a8/XXcolrFZzyKDwkDX0=
Date: Fri, 12 Nov 2010 12:02:15 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Stefan Achatz <stefan_achatz@web.de>,
        "Eric W. Biederman" <ebiederm@aristanetworks.com>,
        "Serge E. Hallyn" <serue@us.ibm.com>, Tejun Heo <tj@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benjamin Thery <benjamin.thery@bull.net>
Subject: Re: [PATCH 1/2] sysfs: Introducing sysfs_create_bin_group()
Message-ID: <20101112200215.GD1299@core.coreip.homeip.net>
References: <1289585918.2629.12.camel@neuromancer>
 <20101112192958.GA22233@suse.de>
 <20101112193817.GA1299@core.coreip.homeip.net>
 <20101112195010.GA23000@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101112195010.GA23000@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 11:50:10AM -0800, Greg KH wrote:
> On Fri, Nov 12, 2010 at 11:38:17AM -0800, Dmitry Torokhov wrote:
> > On Fri, Nov 12, 2010 at 11:29:58AM -0800, Greg KH wrote:
> > > On Fri, Nov 12, 2010 at 07:18:38PM +0100, Stefan Achatz wrote:
> > > > Implemented group functions for easier creation of multiple binary sysfs
> > > > attributes similar to existing attribute_group handling functions.
> > > > The code reuses struct attribute_group instead of inventing a new struct
> > > > binary_attribute_group.
> > > > 
> > > > Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
> > > 
> > > Looks good to me, nice job.
> > > 
> > > Dmitry, do you want to take this through your tree as the mouse driver
> > > change needs it?  If so, feel free to do so and add a:
> > > 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> > > 
> > > to the patch.
> > > 
> > > If not, I'll be glad to take it, and the mouse driver change through my
> > > tree if needed.
> > > 
> > > Just let me know which is easier for you.
> > > 
> > 
> > Actually the driver lives in hid so it's up to Jiri how he wants to
> > handle this.
> 
> Ah.  He's on vacation for a few weeks so I guess I'll take this for now.
> 

Those Europeans with their long vacations, geeze... Well, I hope he's
having fun ;)

-- 
Dmitry
