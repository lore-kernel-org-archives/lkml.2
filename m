Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab0LALPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 06:15:47 -0500
Received: from cantor.suse.de ([195.135.220.2]:37560 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526Ab0LALPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 06:15:46 -0500
Date: Wed, 1 Dec 2010 12:15:40 +0100
From: "Dr. Werner Fink" <werner@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
Message-ID: <20101201111539.GA12029@boole.suse.de>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Greg KH <greg@kroah.com>, Lennart Poettering <mzxreary@0pointer.de>,
	Kay Sievers <kay.sievers@vrfy.org>, Valdis.Kletnieks@vt.edu,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Randy Dunlap <rdunlap@xenotime.net>, Jiri Slaby <jslaby@suse.cz>
References: <20101118112335.434de53a@lxorguk.ukuu.org.uk>
 <20101118121256.GA19884@boole.suse.de>
 <20101118125822.16718289@lxorguk.ukuu.org.uk>
 <20101118131420.GA23872@boole.suse.de>
 <20101118144123.5417ccbd@lxorguk.ukuu.org.uk>
 <20101119132145.GA22883@boole.suse.de>
 <20101119154705.7829487a@lxorguk.ukuu.org.uk>
 <20101119180258.GA6745@kroah.com>
 <20101119184150.GA8997@boole.suse.de>
 <20101120124020.43710d91@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101120124020.43710d91@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 12:40:20PM +0000, Alan Cox wrote:
> > Uhmm ... just to say it: I've been asked by Fedorea people and also
> > by Debian people why I had not submitted this patch and I've told
> > them that I had it done long time ago ;)
> > 
> > It seems to me that there is some demand but most user space
> > monitoring applications uses workarounds (AFAICR plymouth
> > uses hard coded VT for boot and shutdown).
> 
> I think the market won the argument on this one - so please yes - submit
> it.

Just to be sure, do you have noticed my mail with the
ID <20101119170736.GA4177@boole.suse.de> which had
attached the the patch?

   Werner

-- 
System V style init programs - http://savannah.nongnu.org/projects/sysvinit/
