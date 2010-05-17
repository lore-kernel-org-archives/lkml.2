Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab0EQR5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 13:57:49 -0400
Received: from fifo99.com ([67.223.236.141]:37199 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657Ab0EQR5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 13:57:47 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
From: Daniel Walker <dwalker@fifo99.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Matthew Garrett <mjg@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Brian Swetland <swetland@google.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Geoff Smith <geoffx.smith@intel.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       linux-omap@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1274115885.4418.59.camel@mulgrave.site>
References: <Pine.LNX.4.44L0.1005151716180.24645-100000@netrider.rowland.org>
	 <87hbm6cz90.fsf@deeprootsystems.com>
	 <1274115885.4418.59.camel@mulgrave.site>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 10:57:19 -0700
Message-ID: <1274119039.25625.12.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 13:04 -0400, James Bottomley wrote:

> I'm not sure this is real world, either.  Developers can fire up
> powertop from the command line when their phone isn't idling for as long
> as it should.  But a phone is a consumer device: the average smart phone
> user just wants to browse the web, get email, go to facebook and play
> with some cool apps.  If one of those cool apps is rogue, they're not
> really going to know which one or how to find it (and firing up powertop
> from the command line isn't something which will occur to them as a
> matter of routine).
> 
> One of the nice things that suspend blockers actually does is to give
> the kernel a clear name for the process blocking suspend (and thus
> consuming power).  This allows a nice way to assign power budget to the
> application and present who's using what in a nice visible form, which
> does facilitate the reporting of bad apps, even for the non-developer
> user.

If you have an idle based PM system you could get the same information
from having scheduler statistics. Since the "bad" apps are the ones that
are always either running or ready to run, and they would hardly ever
sleep. I don't know if there are specific scheduler statistics for that,
but it doesn't seem like it would be hard to make. It's even much more
natural than getting statistics from suspend blockers, since it requires
the app to be custom made to use suspend blockers.

Daniel

