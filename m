Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab1EOXfr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 19:35:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53511 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab1EOXfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 19:35:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [Bug #33242] Lockdep splat in autofs with 2.6.39-rc2
Date: Mon, 16 May 2011 01:36:13 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <So1vU2GC7XM.A.5wB.44vzNB@chimera> <HA8urZ3ZRcP.A.TvC.O6vzNB@chimera> <20110515232509.GA11642@elliptictech.com>
In-Reply-To: <20110515232509.GA11642@elliptictech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105160136.14177.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 16, 2011, Nick Bowler wrote:
> On 2011-05-15 00:18 +0200, Rafael J. Wysocki wrote:
> > The following bug entry is on the current list of known regressions
> > from 2.6.38.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33242
> > Subject		: Lockdep splat in autofs with 2.6.39-rc2
> > Submitter	: Nick Bowler <nbowler@elliptictech.com>
> > Date		: 2011-04-07 19:44 (38 days old)
> > Message-ID	: <20110407194403.GA29404@elliptictech.com>
> > References	: http://marc.info/?l=linux-kernel&m=130220545614682&w=2
> 
> This one is tough to reproduce, but I imagine that it's still present in
> mainline because I haven't heard anything about it since I was asked to
> test the patch here:
> 
>   http://permalink.gmane.org/gmane.linux.kernel/1129741

Thanks for the update.

Rafael
