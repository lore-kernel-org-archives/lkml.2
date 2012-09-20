Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab2ITWEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 18:04:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48699 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036Ab2ITWEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 18:04:42 -0400
Date: Thu, 20 Sep 2012 15:02:04 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: walter harms <wharms@bfs.de>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] da9052-battery: don't free IRQ that wasn't requested
Message-ID: <20120920220204.GE18223@lizard>
References: <20120905123440.GF6128@elgon.mountain>
 <50475D75.2040908@bfs.de>
 <20120906150758.GL19410@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120906150758.GL19410@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 08:07:58AM -0700, Dan Carpenter wrote:
[...]
> >    for (j=0; j <= i ;j++ ) {
>                ^^^^^^
> The count up loops are prone to the exact same off by one bugs.  ;)
> You've got one in your sample code.  Plus I'd have to declare
> another variable and send a v2 patch and I am very lazy...  So in
> this case I think should just take my original patch.

Applied, thank you!
