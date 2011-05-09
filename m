Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab1EITRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 15:17:07 -0400
Received: from mail.perches.com ([173.55.12.10]:1394 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555Ab1EITRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 15:17:05 -0400
Subject: Re: [PATCH net-next 5/4] tulip: xircom_cb: Remove useless
 func_enter and func_exit
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110509.121026.28826727.davem@davemloft.net>
References: <cover.1304733889.git.joe@perches.com>
	 <20110509.114706.189685729.davem@davemloft.net>
	 <1304968081.19586.66.camel@Joe-Laptop>
	 <20110509.121026.28826727.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 12:17:03 -0700
Message-ID: <1304968623.19586.68.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-09 at 12:10 -0700, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Mon, 09 May 2011 12:08:01 -0700
> > On Mon, 2011-05-09 at 11:47 -0700, David Miller wrote:
> >> With the advent of the function tracer, those silly function entry/exit
> >> logging things are entirely superfluous.
> >> They make the code look ugly too.
> > I don't much like a lot of debugging messages
> > throughout drivers/net, but that's a whole 'nother
> > set of patches.
> >> Please do that and respin this patch set, thanks Joe!
> > How 'bout I just add another patch to delete them.
> > Signed-off-by: Joe Perches <joe@perches.com>
> How about you just respin the patch set as I asked you to?
> It makes no sense to "fix" something you're just going to
> delete in the very next commit.

Grumble.
'Cause it's about 20 minutes work for almost _no_ value.


