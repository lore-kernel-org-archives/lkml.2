Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab0FWVVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 17:21:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43517 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab0FWVVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 17:21:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [Bug #16172] 2.6.25-rc1 ahci regression
Date: Wed, 23 Jun 2010 23:19:09 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Jeff Garzik <jgarzik@redhat.com>, Luming Yu <luming.yu@gmail.com>
References: <lc60d4toGTL.A.QzD._LpHMB@chimera> <W8JfMs9cZw.A.6TG.fNpHMB@chimera> <4C22706E.9020005@garzik.org>
In-Reply-To: <4C22706E.9020005@garzik.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006232319.09562.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 23, 2010, Jeff Garzik wrote:
> On 06/20/2010 06:17 PM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.34.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16172
> > Subject		: 2.6.25-rc1 ahci regression
> > Submitter	: Luming Yu<luming.yu@gmail.com>
> > Date		: 2010-06-03 7:02 (18 days old)
> > First-Bad-Commit: http://git.kernel.org/linus/365cfa1ed5a36f9bcb9f64c9f0f52155af2e9fef
> > Message-ID	:<AANLkTikWak8i-Kaj-e-EUFWE66tfMmp2UPhGJCKkK1zK@mail.gmail.com>>
> > References	: http://marc.info/?l=linux-kernel&m=127554855724361&w=2
> 
> As noted in the bug, this is IMO a problem of certain userlands not 
> properly digesting module dependencies...

OK, closed.

Rafael
