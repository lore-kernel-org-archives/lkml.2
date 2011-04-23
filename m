Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab1DWSEx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 14:04:53 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:44651 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab1DWSEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 14:04:52 -0400
Date: Sat, 23 Apr 2011 20:04:51 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ben Hutchings <ben@decadent.org.uk>, Michal Marek <mmarek@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
        Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH] kconfig: Avoid buffer underrun in choice input
Message-ID: <20110423180450.GB25379@merkur.ravnborg.org>
References: <1303580576.4815.3.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303580576.4815.3.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 23, 2011 at 06:42:56PM +0100, Ben Hutchings wrote:
> commit 40aee729b350672c2550640622416a855e27938f ('kconfig: fix default
> value for choice input') fixed some cases where kconfig would select
> the wrong option from a choice with a single valid option and thus
> enter an infinite loop.
> 
> However, this broke the test for user input of the form 'N?', because
> when kconfig selects the single valid option the input is zero-length
> and the test will read the byte before the input buffer.  If this
> happens to contain '?' (as it will in a mips build on Debian unstable
> today) then kconfig again enters an infinite loop.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Cc: stable@kernel.org [2.6.17+]
> ---
> Roman has failed to respond to this after 5 weeks and one reminder, so
> please take it directly.

No-one has heard from Roman Zippel in several years.
I have suggested Michal Marek to take over the maintainer
role - as he in practice is the kconfig maintainer.

	Sam
