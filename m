Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab2FZO35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 10:29:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757243Ab2FZO34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 10:29:56 -0400
Date: Tue, 26 Jun 2012 16:28:37 +0200
From: Anton Arapov <anton@redhat.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Bastien ROUCARIES <roucaries.bastien@gmail.com>,
        Josh Hunt <joshhunt00@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
        Arnaud Lacombe <lacombar@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: Kerneloops.org defunct?
Message-ID: <20120626142837.GB20573@bandura.brq.redhat.com>
References: <20110601212432.2677b03a.rdunlap@xenotime.net>
 <201106211534.10366.roucaries.bastien@gmail.com>
 <CAE2SPAa=AD=YGyLJn2bX4E8Mu70BaXGi2CvL_fikPKP1gab7+g@mail.gmail.com>
 <20110826173517.7321c086@lxorguk.ukuu.org.uk>
 <CAE2SPAYuYTYj9ukDzitKs+d2uKZacJ5eFo7N+-p9pWgf1MWW2w@mail.gmail.com>
 <20120625180536.GA29261@roeck-us.net>
 <4FE8A9C0.3050802@linux.intel.com>
 <20120625191233.GA29324@roeck-us.net>
 <20120626071430.GA16299@bandura.brq.redhat.com>
 <4FE9B60F.8050407@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE9B60F.8050407@linux.intel.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 06:15:59AM -0700, Arjan van de Ven wrote:
> On 6/26/2012 12:14 AM, Anton Arapov wrote:
> >  I created kerneloops.descope.org with submitoops.php and latest.php
> > in order to not loose the oopses reports. Also asked Arjan to change the
> > IP of kerneloops.org's DNS record so that it point to
> I've seen no such request.

  I used your email at infradead.org ... seems that was the problem.
So, could you update DNS record of *.kerneloops.org to point to 23.20.153.183.

Thank you,
Anton.
