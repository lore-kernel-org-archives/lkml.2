Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab2GTI2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 04:28:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab2GTI2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 04:28:43 -0400
Date: Fri, 20 Jul 2012 10:28:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] [TRIVIAL] treewide: fix four odd angle bracket
 includes
In-Reply-To: <1341006775.1911.59.camel@x61.thuisdomein>
Message-ID: <alpine.LNX.2.00.1207201026490.21929@pobox.suse.cz>
References: <1341006775.1911.59.camel@x61.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2012, Paul Bolle wrote:

> The paths of the headers included by four "angle brackets includes"
> start with "..". So these includes are used to include headers that are
> not actually found in the include search path. Then we might as well
> include these headers using quote marks and paths that link directly to
> these headers.

Right, but ... I don't really see the value of switching either way, do 
you?

> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) mtip32xx.c and progress.h were compile tested. The other two files
> are $EDITOR tested only. (Ie, my $EDITOR knows how to jump to the
> included header from these #include lines, so the preprocessor must
> surely know how to do that too.)
> 
> 1) board-rx51-peripherals.c includes a header from a staging driver.
> That's, well, surprising.

Now, that is ugly. Adding Tony Lindgren to CC.

-- 
Jiri Kosina
SUSE Labs
