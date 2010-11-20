Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab0KTPxI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 10:53:08 -0500
Received: from cantor.suse.de ([195.135.220.2]:43488 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab0KTPxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 10:53:07 -0500
Date: Sat, 20 Nov 2010 07:50:39 -0800
From: Greg KH <gregkh@suse.de>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [00/66] 2.6.36.1-stable review
Message-ID: <20101120155039.GA28803@suse.de>
References: <20101119220309.GA15562@kroah.com> <1290268602.10615.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290268602.10615.2.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 04:56:42PM +0100, Thomas Meyer wrote:
> Am Freitag, den 19.11.2010, 14:03 -0800 schrieb Greg KH:
> > This is the start of the stable review cycle for the 2.6.36.1 release.
> > There are 66 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let us know.  If anyone is a maintainer of the proper subsystem, and
> > wants to add a Signed-off-by: line to the patch, please respond with it.
> 
> This one is missing and crashes my 2.6.36 kernel:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=22922
> 
> This was fixed in 2.6.37-rc1 in commit: a1c6c5698d53 (ext4: fix
> NULL pointer dereference in print_daily_error_info())

You need to get the ext4 maintainers to ack that and let me know about
it before I can add it.

thanks,

greg k-h
