Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282Ab2FZHPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 03:15:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab2FZHPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 03:15:51 -0400
Date: Tue, 26 Jun 2012 09:14:30 +0200
From: Anton Arapov <anton@redhat.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Bastien ROUCARIES <roucaries.bastien@gmail.com>,
        Josh Hunt <joshhunt00@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
        Arnaud Lacombe <lacombar@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: Kerneloops.org defunct?
Message-ID: <20120626071430.GA16299@bandura.brq.redhat.com>
References: <4DE6264A.2040901@gmail.com>
 <20110601212432.2677b03a.rdunlap@xenotime.net>
 <201106211534.10366.roucaries.bastien@gmail.com>
 <CAE2SPAa=AD=YGyLJn2bX4E8Mu70BaXGi2CvL_fikPKP1gab7+g@mail.gmail.com>
 <20110826173517.7321c086@lxorguk.ukuu.org.uk>
 <CAE2SPAYuYTYj9ukDzitKs+d2uKZacJ5eFo7N+-p9pWgf1MWW2w@mail.gmail.com>
 <20120625180536.GA29261@roeck-us.net>
 <4FE8A9C0.3050802@linux.intel.com>
 <20120625191233.GA29324@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120625191233.GA29324@roeck-us.net>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 12:12:33PM -0700, Guenter Roeck wrote:
> On Mon, Jun 25, 2012 at 11:11:12AM -0700, Arjan van de Ven wrote:
> > On 6/25/2012 11:05 AM, Guenter Roeck wrote:
> > > Did anyone ever get access to the kerneloops code and/or is working on a
> > > replacement ?
> > > I see that http://kerneloops-descope.rhcloud.com/submitoops.php appears to
> > > accept kerneloops reports, http://kerneloops-descope.rhcloud.com/ reports
> > > "www.kerneloops.org, coming soon", and a comment in
> > > https://bugzilla.redhat.com/show_bug.cgi?id=800302 suggests that Redhat may be
> > > in the process of taking over kerneloops.org.
> > I hope RH is willing to invest the time in this; I do not have access to
> > the latest code anymore (it lived on the kernel.org servers prior to the
> > incident)
> Maybe we can get some feedback from RH. Anton, can you shed some light about
> what is happening, if anything ?

  I can't promise, but there will be a person in Red Hat, who will be
working on 'kerneloops.org' starting from middle of next month. I will 
update you in a couple weeks whether it happened or not.
  I created kerneloops.descope.org with submitoops.php and latest.php
in order to not loose the oopses reports. Also asked Arjan to change the
IP of kerneloops.org's DNS record so that it point to kerneloops.descope.org,
at least temporary, but it didn't happen yet. :(
  All in all, it seems to be optimistic so far, and I hope we will
have some web gui this summer. Although we don't have much oopses
reported yet and changing the ip address of kerneloops.org, as
mentioned before, might help.

Anton.
