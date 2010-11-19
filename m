Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab0KSSmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 13:42:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36228 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756374Ab0KSSl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 13:41:56 -0500
Date: Fri, 19 Nov 2010 19:41:50 +0100
From: "Dr. Werner Fink" <werner@suse.de>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
Message-ID: <20101119184150.GA8997@boole.suse.de>
Mail-Followup-To: Greg KH <greg@kroah.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Lennart Poettering <mzxreary@0pointer.de>,
	Kay Sievers <kay.sievers@vrfy.org>, Valdis.Kletnieks@vt.edu,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Randy Dunlap <rdunlap@xenotime.net>, Jiri Slaby <jslaby@suse.cz>
References: <20101118015310.GA30480@kroah.com>
 <20101118110020.GA13871@boole.suse.de>
 <20101118112335.434de53a@lxorguk.ukuu.org.uk>
 <20101118121256.GA19884@boole.suse.de>
 <20101118125822.16718289@lxorguk.ukuu.org.uk>
 <20101118131420.GA23872@boole.suse.de>
 <20101118144123.5417ccbd@lxorguk.ukuu.org.uk>
 <20101119132145.GA22883@boole.suse.de>
 <20101119154705.7829487a@lxorguk.ukuu.org.uk>
 <20101119180258.GA6745@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101119180258.GA6745@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 10:02:58AM -0800, Greg KH wrote:
> On Fri, Nov 19, 2010 at 03:47:05PM +0000, Alan Cox wrote:
> > > Currently the bootlogd(8) or blogd(8) parse the kernels command line
> > > and if available do an ioctl TIOCGDEV (not supported by the upstream
> > > kernel), then create a pty/tty pair, do an ioctl TIOCCONS to forward
> > 
> > So perhaps the vendors using TIOCGDEV could get off their collective
> > backsides and submit it upstream ?
> 
> Heh, that's what started this whole thing :)
> 
> I objected to TIOCGDEV going in as it seemed that only suse needed it
> for their boot sequence, and no other distro did which implied that it
> really wasn't necessary.
> 
> I'm still not convinced it is needed, and the many thousands of booting
> systems out there without it seem to confirm it...

Uhmm ... just to say it: I've been asked by Fedorea people and also
by Debian people why I had not submitted this patch and I've told
them that I had it done long time ago ;)

It seems to me that there is some demand but most user space
monitoring applications uses workarounds (AFAICR plymouth
uses hard coded VT for boot and shutdown).


  Werner

-- 
System V style init programs - http://savannah.nongnu.org/projects/sysvinit/
