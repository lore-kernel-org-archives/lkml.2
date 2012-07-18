Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab2GRFaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 01:30:20 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:52851 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752595Ab2GRFaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 01:30:18 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18E1C5q58gE8OYT0AvVaByLwQrIBn1AcqH7PgR/bd
	av5zdwVPVXx4qX
Message-ID: <1342589411.7321.59.camel@marge.simpson.net>
Subject: Re: Deadlocks due to per-process plugging
From: Mike Galbraith <efault@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        mgalbraith@suse.com, Steven Rostedt <rostedt@goodmis.org>
Date: Wed, 18 Jul 2012 07:30:11 +0200
In-Reply-To: <1342586692.7321.45.camel@marge.simpson.net>
References: <20120711133735.GA8122@quack.suse.cz>
	 <x49ehoii8ps.fsf@segfault.boston.devel.redhat.com>
	 <20120711201601.GB9779@quack.suse.cz>
	 <alpine.LFD.2.02.1207121552111.32033@ionos>
	 <20120713123318.GB20361@quack.suse.cz>
	 <alpine.LFD.2.02.1207131444490.32033@ionos>
	 <20120713144622.GB28715@quack.suse.cz>
	 <alpine.LFD.2.02.1207151057010.32033@ionos>
	 <1342343673.28142.2.camel@marge.simpson.net>
	 <1342405366.7659.35.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1207161058550.32033@ionos>
	 <1342432094.7659.39.camel@marge.simpson.net>
	 <1342433303.7659.42.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1207161216200.32033@ionos>
	 <1342530621.7353.116.camel@marge.simpson.net>
	 <1342586692.7321.45.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-18 at 06:44 +0200, Mike Galbraith wrote:

> The patch in question for missing Cc.  Maybe should be only mutex, but I
> see no reason why IO dependency can only possibly exist for mutexes...

Well that was easy, box quickly said "nope, mutex only does NOT cut it".

-Mike

