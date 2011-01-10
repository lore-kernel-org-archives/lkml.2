Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab1AJWBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 17:01:05 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:59397 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958Ab1AJWBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 17:01:03 -0500
Date: Mon, 10 Jan 2011 14:01:00 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcutorture: Get rid of duplicate sched.h include
Message-ID: <20110110220100.GM2383@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LNX.2.00.1101102141230.32164@swampdragon.chaosbits.net>
 <20110110215039.GA14492@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110110215039.GA14492@feather>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 01:50:39PM -0800, Josh Triplett wrote:
> On Mon, Jan 10, 2011 at 09:43:13PM +0100, Jesper Juhl wrote:
> > linux/sched.h is included twice in kernel/rcutorture.c - once is enough.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> Looks like the duplicate include appeared in
> 8e8be45e8e55daa381028aec339829929ddb53a5.

Looks like something I would do.  :-/

I have queued the patch and added Josh's Reviewed-by -- thank you both!

							Thanx, Paul
