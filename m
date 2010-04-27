Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab0D0Mxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:53:31 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:56114 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab0D0Mx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:53:29 -0400
Date: Tue, 27 Apr 2010 14:53:24 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Nicolas Palix <npalix@diku.dk>, Andrew Morton <akpm@linux-foundation.org>,
       Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
       Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
       Gilles Muller <Gilles.Muller@lip6.fr>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, cocci@diku.dk
Subject: Re: [PATCH 0/4] Add a Coccinelle front-end script
In-Reply-To: <20100427125014.GD1775@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1004271452250.27092@ask.diku.dk>
References: <1272316279-12042-1-git-send-email-npalix@diku.dk>
 <20100427125014.GD1775@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010, Wolfram Sang wrote:

> On Mon, Apr 26, 2010 at 11:11:15PM +0200, Nicolas Palix wrote:
> > New targets are added (coccicheck-<mode>) to call the spatch front-end
> > in the 'scripts' directory with the <mode> argument.
> > 
> > Four modes are defined: report, patch, context, and org.
> > 
> > 'report' mode generates a list in the following format:
> >   file:line:column-column: message
> > 
> > 'patch' mode proposes a generic fix, when possible.
> > 
> > 'context' mode highlights lines of interest and their context
> > in a diff-like style.
> > 
> > 'org' mode generates a report in the Org mode format of Emacs.
> 
> So, as I understood all semantic patches have to support 'org'?
> I think this makes submitting slightly more complicated...

No, this should not be the case.  It just won't do anything if you request 
org output and nothing is defined to produce org output.

julia
