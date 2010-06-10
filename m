Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870Ab0FJLwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:52:11 -0400
Received: from 8bytes.org ([88.198.83.132]:41043 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758786Ab0FJLwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:52:08 -0400
Date: Thu, 10 Jun 2010 13:52:06 +0200
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
       Kernel Janitors <kernel-janitors@vger.kernel.org>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Andy Isaacson <adi@hexapodia.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, walter harms <wharms@bfs.de>,
       Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 0/7] Add some checks to be used with Coccinelle
Message-ID: <20100610115205.GA8302@8bytes.org>
References: <1275837307-4283-1-git-send-email-npalix@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275837307-4283-1-git-send-email-npalix@diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 06, 2010 at 05:15:00PM +0200, Nicolas Palix wrote:
> This patch series adds a front-end to use Coccinelle.  It also
> includes a documentation file describing how to use the new
> 'coccicheck' target. Finally, some SmPL examples are provided.
> 
> Signed-off-by: Nicolas Palix <npalix@diku.dk>
> Signed-off-by: Julia Lawall <julia@diku.dk>

Looks good to me. Hope we will see lot of more scripts in the future :-)

Acked-by: Joerg Roedel <joerg.roedel@amd.com>

