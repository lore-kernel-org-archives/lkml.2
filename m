Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab2KHVmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:42:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47451 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756690Ab2KHVmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:42:53 -0500
Date: Thu, 8 Nov 2012 22:42:42 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joe Perches <joe@perches.com>, linux-alpha@vger.kernel.org
Subject: Re: [PATCH] alpha: use BUG_ON where possible
In-Reply-To: <1352406191-14303-2-git-send-email-sasha.levin@oracle.com>
Message-ID: <alpine.LNX.2.00.1211082242130.27271@pobox.suse.cz>
References: <1352406191-14303-1-git-send-email-sasha.levin@oracle.com> <1352406191-14303-2-git-send-email-sasha.levin@oracle.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2012, Sasha Levin wrote:

> Just use BUG_ON() instead of constructions such as:
> 
> 	if (...)
> 		BUG()
> 
> A simplified version of the semantic patch that makes this transformation
> is as follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e;
> @@
> - if (e) BUG();
> + BUG_ON(e);

Ok, I guess I am just going to apply this one. Thanks,

-- 
Jiri Kosina
SUSE Labs
