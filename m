Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab1JYUzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 16:55:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48238 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab1JYUze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 16:55:34 -0400
Date: Tue, 25 Oct 2011 22:51:06 +0200
From: Greg KH <gregkh@suse.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Greg KH <greg@kroah.com>, Nhan H Mai <nhan.h.mai@intel.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        alan@linux.intel.com
Subject: Re: [PATCH] serial/8250_pci: add a quirk for the kt serial controller
Message-ID: <20111025205106.GD7234@suse.de>
References: <20111023222711.22713.11434.stgit@localhost6.localdomain6>
 <20111025022852.GB32457@kroah.com>
 <1319573794.9320.15.camel@dwillia2-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319573794.9320.15.camel@dwillia2-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 01:16:34PM -0700, Dan Williams wrote:
> From: Dan Williams <dan.j.williams@intel.com>
> Date: Sun, 23 Oct 2011 15:06:24 -0700
> Subject: [PATCH v2] serial/8250_pci: add a quirk for the kt serial controller
> 
> Workaround dropped notifications in the iir register.  Prevent reads
> coincident with new interrupt notifications by reading the iir at most
> once per interrupt.
> 
> Reported-by: Nhan H Mai <nhan.h.mai@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Much better.

But.

Do you really think I can apply a patch that looks like this above?  I
have to edit the text of the email before I apply it.

Now I'm a bit grumpy about this at the moment as Linus yelled at me for
patches where I missed this on a few for the 3.2 merge window, so I'm
going to push back on people now very hard.

Please send this in a format that I can run 'git am' on the email you
send me.  I could not do that here, otherwise we would end up with a
duplicate header in the changelog message.

Yes, it makes you do a bit more work, but when you are handling
thousands of patches like me, you scale better than I do :)

Actually, it's just making you do it properly, along with everyone else,
which is a good thing, right?

thanks,

greg k-h
