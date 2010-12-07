Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab0LGU0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 15:26:46 -0500
Received: from kroah.org ([198.145.64.141]:36150 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab0LGU0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 15:26:44 -0500
Date: Tue, 7 Dec 2010 12:18:51 -0800
From: Greg KH <greg@kroah.com>
To: Greg KH <gregkh@suse.de>
Cc: Thomas Meyer <thomas@m3y3r.de>, linux-kernel@vger.kernel.org,
        stable@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [00/66] 2.6.36.1-stable review
Message-ID: <20101207201851.GA11264@kroah.com>
References: <20101119220309.GA15562@kroah.com>
 <1290268602.10615.2.camel@localhost.localdomain>
 <20101120155039.GA28803@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101120155039.GA28803@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 07:50:39AM -0800, Greg KH wrote:
> On Sat, Nov 20, 2010 at 04:56:42PM +0100, Thomas Meyer wrote:
> > Am Freitag, den 19.11.2010, 14:03 -0800 schrieb Greg KH:
> > > This is the start of the stable review cycle for the 2.6.36.1 release.
> > > There are 66 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let us know.  If anyone is a maintainer of the proper subsystem, and
> > > wants to add a Signed-off-by: line to the patch, please respond with it.
> > 
> > This one is missing and crashes my 2.6.36 kernel:
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=22922
> > 
> > This was fixed in 2.6.37-rc1 in commit: a1c6c5698d53 (ext4: fix
> > NULL pointer dereference in print_daily_error_info())
> 
> You need to get the ext4 maintainers to ack that and let me know about
> it before I can add it.

As the ext4 maintainers seem to ignoring the stable trees now for some
reason, I'll just apply this and see who complains :)

thanks,

greg k-h
