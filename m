Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab0DTRSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 13:18:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42124 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab0DTRSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 13:18:06 -0400
Date: Tue, 20 Apr 2010 19:18:04 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jeff Dike <jdike@addtoit.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, Jan Kiszka <jan.kiszka@web.de>,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH 2/5] uml: Drop private round_down
 definition
In-Reply-To: <20100420165225.GA31439@c-98-229-117-200.hsd1.ma.comcast.net>
Message-ID: <alpine.LNX.2.00.1004201917520.7579@pobox.suse.cz>
References: <cover.1271713955.git.jan.kiszka@web.de> <74c7d668690f283cf3b8aed92004dc72e872f7ce.1271713955.git.jan.kiszka@web.de> <20100420083358.GD4356@cr0.nay.redhat.com> <alpine.LNX.2.00.1004201635050.7579@pobox.suse.cz>
 <20100420165225.GA31439@c-98-229-117-200.hsd1.ma.comcast.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Apr 2010, Jeff Dike wrote:

> > > Shouldn't this signal.c #include <linux/kernel.h>?
> > 
> > Well, it gets included implicitly through uaccess.h -> sched.h -> 
> > kernel.h.
> 
> You're depending on the internal details of uaccess.h and sched.h.  If
> either of them changed, then this would cause unexpected compile
> failures here.
> 
> Better to explicitly include kernel.h.

Yeah, I have that already in my tree.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
