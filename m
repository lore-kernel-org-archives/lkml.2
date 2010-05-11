Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107Ab0EKCOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 22:14:19 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:46411 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab0EKCOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 22:14:17 -0400
Date: Mon, 10 May 2010 19:14:16 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Nicolas Palix <npalix@diku.dk>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Roland Dreier <rdreier@cisco.com>,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Julia Lawall <julia@diku.dk>,
       Gilles Muller <Gilles.Muller@lip6.fr>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, cocci@diku.dk,
       Wolfram Sang <w.sang@pengutronix.de>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 0/4] Add a Coccinelle front-end script
Message-ID: <20100511021416.GA7125@hexapodia.org>
References: <1273508667-5152-1-git-send-email-npalix@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273508667-5152-1-git-send-email-npalix@diku.dk>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 06:24:23PM +0200, Nicolas Palix wrote:
> New targets are added (coccicheck-<mode>) to call the 'coccinelle.sh'
> front-end in the 'scripts' directory with the <mode> argument.
> 
> Four modes are defined: report, patch, context, and org.

Please check-in this write-up somewhere (Documentation/README.coccinelle
perhaps?) along with information about how to get the required tools.
(Are they pacakged in Debian and/or Fedora?  What versions are the
scripts tested against?)

Also I'd like to see a short example of how to use the framework.  I've
read Val's spatch article (http://lwn.net/Articles/315686/) and it's
still a bit of a black art to me.

Thanks for the work!

-andy
