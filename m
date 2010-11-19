Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab0KSSJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 13:09:25 -0500
Received: from kroah.org ([198.145.64.141]:37833 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755607Ab0KSSJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 13:09:24 -0500
Date: Fri, 19 Nov 2010 10:02:58 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Dr. Werner Fink" <werner@suse.de>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
Message-ID: <20101119180258.GA6745@kroah.com>
References: <20101118014848.GA7873@tango.0pointer.de>
 <20101118015310.GA30480@kroah.com>
 <20101118110020.GA13871@boole.suse.de>
 <20101118112335.434de53a@lxorguk.ukuu.org.uk>
 <20101118121256.GA19884@boole.suse.de>
 <20101118125822.16718289@lxorguk.ukuu.org.uk>
 <20101118131420.GA23872@boole.suse.de>
 <20101118144123.5417ccbd@lxorguk.ukuu.org.uk>
 <20101119132145.GA22883@boole.suse.de>
 <20101119154705.7829487a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101119154705.7829487a@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 03:47:05PM +0000, Alan Cox wrote:
> > Currently the bootlogd(8) or blogd(8) parse the kernels command line
> > and if available do an ioctl TIOCGDEV (not supported by the upstream
> > kernel), then create a pty/tty pair, do an ioctl TIOCCONS to forward
> 
> So perhaps the vendors using TIOCGDEV could get off their collective
> backsides and submit it upstream ?

Heh, that's what started this whole thing :)

I objected to TIOCGDEV going in as it seemed that only suse needed it
for their boot sequence, and no other distro did which implied that it
really wasn't necessary.

I'm still not convinced it is needed, and the many thousands of booting
systems out there without it seem to confirm it...

thanks,

greg k-h
