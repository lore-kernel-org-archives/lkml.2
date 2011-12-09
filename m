Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab1LIPtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 10:49:55 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:41325 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754471Ab1LIPtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 10:49:53 -0500
Message-ID: <1323445790.27746.10.camel@joe2Laptop>
Subject: Re: [PATCH 2/8] MAINTAINERS: tm6000: Update F: patterns
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Dmitri Belimov <d.belimov@gmail.com>,
        Stefan Ringel <linuxtv@stefanringel.de>
Date: Fri, 09 Dec 2011 07:49:50 -0800
In-Reply-To: <4EE1EC7F.4060909@redhat.com>
References: <cover.1323418149.git.joe@perches.com>
	 <c161ff9b75651d9da542fa657bc282ea25c508c5.1323418149.git.joe@perches.com>
	 <4EE1EC7F.4060909@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-09 at 09:09 -0200, Mauro Carvalho Chehab wrote:
> On 09-12-2011 06:12, Joe Perches wrote:
> > commit be30497085080 ("[media] move tm6000 to drivers/media/video")
> > move the files, update the F: pattern.
> > diff --git a/MAINTAINERS b/MAINTAINERS
[]
> > @@ -6375,11 +6375,6 @@ M:	Omar Ramirez Luna<omar.ramirez@ti.com>
> >   S:	Odd Fixes
> >   F:	drivers/staging/tidspbridge/
> >
> > -STAGING - TRIDENT TVMASTER TMxxxx USB VIDEO CAPTURE DRIVERS
> > -L:	linux-media@vger.kernel.org
> > -S:	Odd Fixes
> > -F:	drivers/staging/tm6000/
> > -
> >   STAGING - USB ENE SM/MS CARD READER DRIVER
> >   M:	Al Cho<acho@novell.com>
> >   S:	Odd Fixes
> > @@ -6634,6 +6629,11 @@ F:	include/linux/trace*.h
> >   F:	include/trace/
> >   F:	kernel/trace/
> >
> > +TRIDENT TVMASTER TMxxxx USB VIDEO CAPTURE DRIVERS
> > +L:	linux-media@vger.kernel.org
> > +S:	Odd Fixes
> > +F:	drivers/media/video/tm6000/
> > +
[]
> I would either remove this entry or add a new one, cloning from the
> media entry, like:
> 
> TRIDENT TVMASTER TMxxxx USB VIDEO CAPTURE DRIVERS
> M:	Mauro Carvalho Chehab <mchehab@infradead.org>
> P:	LinuxTV.org Project
> L:	linux-media@vger.kernel.org

trivial: I think this "P:" line isn't really correct.
P: is meant for named individuals not collective projects.

> W:	http://linuxtv.org
> Q:	http://patchwork.kernel.org/project/linux-media/list/
> T:	git git://linuxtv.org/media_tree.git
> S:	Maintained
> 
> If we add a new entry, it probably makes sense to add Stefan
> and/or Dmitri as co-maintainers there, if they're ok with that.

The more the merrier as far as I'm concerned.

Andrew, please ignore this one.
Mauro/Dmitri/Stefan, please submit whatever is appropriate.

