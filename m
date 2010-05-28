Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab0E1HJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 03:09:24 -0400
Received: from 8bytes.org ([88.198.83.132]:40853 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121Ab0E1HJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 03:09:22 -0400
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 May 2010 03:09:22 EDT
Date: Fri, 28 May 2010 09:09:21 +0200
From: Joerg Roedel <joro@8bytes.org>
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
Message-ID: <20100528070921.GK1237@8bytes.org>
References: <1273508667-5152-1-git-send-email-npalix@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273508667-5152-1-git-send-email-npalix@diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 06:24:23PM +0200, Nicolas Palix wrote:
> Three semantic patches, with a low rate of false positives, are also
> included.

Is there a way to annotate false positives so that they do not produce
warnings over and over?

> Other semantic patches will be provided later. Note that a semantic
> patch does not need to define all four modes. As many semantic patches
> may be proposed later, they are organized under sub-directories of
> 'scripts/coccinelle/'.

Don't know how complex the coccinelle software itself is, but I think it
would make sense to ship it with the kernel-sources too. That together
with a README and everything is perfect :-)
Thanks for the great work, this should definitly be upstream.

	Joerg

