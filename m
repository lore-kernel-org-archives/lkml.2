Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab0LBLxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 06:53:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51890 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757402Ab0LBLxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 06:53:35 -0500
Date: Thu, 2 Dec 2010 12:53:33 +0100
From: Michal Marek <mmarek@suse.cz>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, stefani@seibold.net
Subject: Re: [RESEND PATCH] tags: put function prototypes back!
Message-ID: <20101202115333.GB18216@sepie.suse.cz>
References: <4C176968.8070807@suse.cz>
 <1288862656-26707-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20101117090654.GZ8942@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101117090654.GZ8942@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 10:06:54AM +0100, Uwe Kleine-König wrote:
> Hello Marek,
> 
> On Thu, Nov 04, 2010 at 10:24:16AM +0100, Uwe Kleine-König wrote:
> > Commit 7db86dc (ctags: usability fix) removed function prototypes from
> > tags file claiming "It makes no real sense to include function
> > prototypes".
> > But it is useful for quickly determining which header file developer
> > needs to include to fix compilation.
> > 
> > Now if someone wants to remove forward declatations (which I agree are
> > baggage), write a postprocessing script.

OK, I applied your patch to kbuild-2.6.git#misc. I initially though it
would be really nice to filter out forward declarations, but gave up on
this.

> While sorting my pending patches I noticed that there's a typo, can you
> please do s/declatations/declarations/ when taking the patch.

Done.

Michal
