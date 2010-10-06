Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759044Ab0JFONN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 10:13:13 -0400
Received: from kroah.org ([198.145.64.141]:36075 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758996Ab0JFONM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 10:13:12 -0400
Date: Wed, 6 Oct 2010 07:02:12 -0700
From: Greg KH <greg@kroah.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: OOM panics with zram
Message-ID: <20101006140212.GB19470@kroah.com>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>
 <1284053081.7586.7910.camel@nimitz>
 <4CA8CE45.9040207@vflare.org>
 <20101005234300.GA14396@kroah.com>
 <4CABDF0E.3050400@vflare.org>
 <20101006023624.GA27685@kroah.com>
 <4CABFB6F.2070800@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CABFB6F.2070800@vflare.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 12:30:39AM -0400, Nitin Gupta wrote:
> > So, should I delete the version in staging, or are you going to send
> > patches to sync it up with your development version?
> > 
> 
> Deleting it from staging would not help much. Much more helpful would
> be to sync at least the mainline and linux-next version of the driver
> so it's easier to develop against these kernel trees.  Initially, I
> thought -staging means that any reviewed change can quickly make it
> to *both* linux-next and more importantly -staging in mainline.

It makes it quickly to linux-next, right?

Nothing goes "quickly" to mainline, other than the normal development
process, which is well documented as to how it all works.

> Working/ Testing against mainline is much smoother than against
> linux-next.

Sure it's "easier", but that's not how kernel development is done,
sorry.  See Documentation/development-process/ for details.

thanks,

greg k-h
