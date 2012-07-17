Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab2GQGlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 02:41:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135Ab2GQGlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 02:41:01 -0400
Message-ID: <1342507240.21627.8.camel@bandura>
Subject: Re: Kerneloops.org defunct?
From: Anton Arapov <anton@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Bastien ROUCARIES <roucaries.bastien@gmail.com>,
        Josh Hunt <joshhunt00@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
        Arnaud Lacombe <lacombar@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Guenter Roeck <linux@roeck-us.net>
Date: Tue, 17 Jul 2012 08:40:40 +0200
In-Reply-To: <20120626071430.GA16299@bandura.brq.redhat.com>
References: <4DE6264A.2040901@gmail.com>
	 <20110601212432.2677b03a.rdunlap@xenotime.net>
	 <201106211534.10366.roucaries.bastien@gmail.com>
	 <CAE2SPAa=AD=YGyLJn2bX4E8Mu70BaXGi2CvL_fikPKP1gab7+g@mail.gmail.com>
	 <20110826173517.7321c086@lxorguk.ukuu.org.uk>
	 <CAE2SPAYuYTYj9ukDzitKs+d2uKZacJ5eFo7N+-p9pWgf1MWW2w@mail.gmail.com>
	 <20120625180536.GA29261@roeck-us.net> <4FE8A9C0.3050802@linux.intel.com>
	 <20120625191233.GA29324@roeck-us.net>
	 <20120626071430.GA16299@bandura.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-26 at 09:14 +0200, Anton Arapov wrote:
> On Mon, Jun 25, 2012 at 12:12:33PM -0700, Guenter Roeck wrote:
> > On Mon, Jun 25, 2012 at 11:11:12AM -0700, Arjan van de Ven wrote:
> > > On 6/25/2012 11:05 AM, Guenter Roeck wrote:
> > > > Did anyone ever get access to the kerneloops code and/or is working on a
> > > > replacement ?
> > > > I see that http://kerneloops-descope.rhcloud.com/submitoops.php appears to
> > > > accept kerneloops reports, http://kerneloops-descope.rhcloud.com/ reports
> > > > "www.kerneloops.org, coming soon", and a comment in
> > > > https://bugzilla.redhat.com/show_bug.cgi?id=800302 suggests that Redhat may be
> > > > in the process of taking over kerneloops.org.
> > > I hope RH is willing to invest the time in this; I do not have access to
> > > the latest code anymore (it lived on the kernel.org servers prior to the
> > > incident)
> > Maybe we can get some feedback from RH. Anton, can you shed some light about
> > what is happening, if anything ?
> 
>   I can't promise, but there will be a person in Red Hat, who will be
> working on 'kerneloops.org' starting from middle of next month. I will 
> update you in a couple weeks whether it happened or not.

  Unfortunately, still no person to work on project. And there are only
2- reports a month in average. :( 
  The reporting tool(Abrt) complicated the reporting and kerneloops.org
DNS still doesn't associated with the required ip address. ( Arjan? )
  - Abrt folks pushed changes into Fedora 17 that makes possible to set
a checkbox("don't ask me again, just report") and Abrt will send reports
without asking.
  - Starting from the Fedora 18 kernel oopses reporting will be
configured to send reports unconditionally, straight to the
kerneloops.org as it did the original tool.
(this, hopefully, will fix the volume of the oopses we are getting.)

Anton.


