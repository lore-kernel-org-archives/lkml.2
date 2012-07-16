Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab2GPKbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 06:31:05 -0400
Received: from nat.nue.novell.com ([195.135.221.2]:35765 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab2GPKbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 06:31:03 -0400
Message-ID: <1342434657.7659.56.camel@marge.simpson.net>
Subject: Re: Deadlocks due to per-process plugging
From: Mike Galbraith <mgalbraith@novell.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        mgalbraith@suse.com
Date: Mon, 16 Jul 2012 12:30:57 +0200
In-Reply-To: <alpine.LFD.2.02.1207161216200.32033@ionos>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(hohum, gmx server went down, back to random address mode;)

On Mon, 2012-07-16 at 12:19 +0200, Thomas Gleixner wrote: 
> 
> That should do the trick.

I'll put it to work on 64 core box, and see if it survives.  It better.

-Mike

