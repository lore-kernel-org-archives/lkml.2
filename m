Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab2DYQaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 12:30:23 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:17754 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab2DYQaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 12:30:21 -0400
Date: Wed, 25 Apr 2012 18:30:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux arch <linux-arch@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>, Richard Weinberger <richard@nod.at>,
        "David S. Miller" <davem@davemloft.net>,
        Arnaud Lacombe <lacombar@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/4] kbuild: link of vmlinux moved to a script
Message-ID: <20120425163019.GB3346@merkur.ravnborg.org>
References: <20120424194148.GA2216@merkur.ravnborg.org> <20120424194431.GC2311@merkur.ravnborg.org> <20120425142452.GA13682@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120425142452.GA13682@elliptictech.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 10:24:52AM -0400, Nick Bowler wrote:
> Hi Sam,
> 
> Without actually running it, a few comments on the shell script itself.

Thanks for a detailed review.
I will address it all or let you know if I fail to address some part of it.

	Sam
