Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab0E1HEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 03:04:22 -0400
Received: from 8bytes.org ([88.198.83.132]:53828 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227Ab0E1HED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 03:04:03 -0400
Date: Fri, 28 May 2010 09:04:01 +0200
From: Joerg Roedel <joro@8bytes.org>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Nicolas Palix <npalix@diku.dk>, Randy Dunlap <rdunlap@xenotime.net>,
       Roland Dreier <rdreier@cisco.com>, Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Julia Lawall <julia@diku.dk>,
       Gilles Muller <Gilles.Muller@lip6.fr>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, cocci@diku.dk,
       Wolfram Sang <w.sang@pengutronix.de>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 1/4] Add targets to use the Coccinelle checker
Message-ID: <20100528070401.GJ1237@8bytes.org>
References: <1273508667-5152-1-git-send-email-npalix@diku.dk> <1273508667-5152-2-git-send-email-npalix@diku.dk> <20100512064230.GC5718@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100512064230.GC5718@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 02:42:30PM +0800, Américo Wang wrote:
> On Mon, May 10, 2010 at 06:24:24PM +0200, Nicolas Palix wrote:
> >Four targets are added. Each one generates a different
> >output kind: context, patch, org, report.
> >Every SmPL file in 'scripts/coccinelle' is given to the spatch frontend
> >(located in the 'scripts' directory), and applied to the entire
> >source tree.
> >
> >Signed-off-by: Nicolas Palix <npalix@diku.dk>
> >Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> This is great!

Totally agreed.

> I would like to see coccinelle to be integrated with kbuild, but the
> name 'coccicheck' is really confusing, how about 'sema_check'? Which
> means 'semantic check'.

I think its okay to keep coccicheck because its the name of the tool
called. We do the same with 'make cscope'.
But since I am a bit lazy I would prefer a shorter name, probably just
'make cocci'?

> Or we can use something like for sparse, i.e. 'make C=1' etc..

Yes, this would also make sense. As a developer I could add this and
only the code I changed is checked.

	Joerg

