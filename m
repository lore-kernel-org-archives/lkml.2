Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437Ab2GOHPB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 03:15:01 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:58280 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751199Ab2GOHOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 03:14:53 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18zwY5UBnMzLSDmy50qSEF6yd1Nlfi1bZHoS4YpaC
	Q32dWtClilQGb/
Message-ID: <1342336487.7484.3.camel@marge.simpson.net>
Subject: Re: Deadlocks due to per-process plugging
From: Mike Galbraith <efault@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        mgalbraith@suse.com
Date: Sun, 15 Jul 2012 09:14:47 +0200
In-Reply-To: <1342263621.7368.36.camel@marge.simpson.net>
References: <20120711133735.GA8122@quack.suse.cz>
	 <x49ehoii8ps.fsf@segfault.boston.devel.redhat.com>
	 <20120711201601.GB9779@quack.suse.cz>
	 <alpine.LFD.2.02.1207121552111.32033@ionos>
	 <20120713123318.GB20361@quack.suse.cz>
	 <alpine.LFD.2.02.1207131444490.32033@ionos>
	 <1342263621.7368.36.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-07-14 at 13:00 +0200, Mike Galbraith wrote: 
> I have your patch burning on my 64 core rt box.  If it survives the
> weekend, you should be able to replace my jbd hack with your fix.

As expected, box is still going strong.  It would have died by now if
the problem were still lurking.

-Mike

