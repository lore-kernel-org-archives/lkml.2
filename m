Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab0DUKtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 06:49:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40551 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044Ab0DUKtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 06:49:15 -0400
Date: Wed, 21 Apr 2010 12:49:11 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Jan Kiszka <jan.kiszka@web.de>, Jeff Dike <jdike@addtoit.com>,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 3/5] uml: Fix warning due to missing task_struct
 declaration
In-Reply-To: <20100421104345.GA4110@cr0.nay.redhat.com>
Message-ID: <alpine.LNX.2.00.1004211244230.7579@pobox.suse.cz>
References: <cover.1271713955.git.jan.kiszka@web.de> <1d97cd7761a1eae73923b1adda4c6915a0647bb3.1271713955.git.jan.kiszka@web.de> <20100420100949.GB5317@cr0.nay.redhat.com> <20100420143016.GB30011@c-98-229-117-200.hsd1.ma.comcast.net> <4BCDDFBB.40805@web.de>
 <20100421060651.GB4467@cr0.nay.redhat.com> <alpine.LNX.2.00.1004211138320.7579@pobox.suse.cz> <20100421104345.GA4110@cr0.nay.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Apr 2010, Amerigo Wang wrote:

> >> BTW, I don't think compile warning fixes are trivial enough to go
> >> to trivial@kernel.org.
> >
> >Why?
> >
> Usually compile warnings fixes go into -mm, some coding style fixes
> too.

Well, I personally don't care that much, submit your patches whereever you 
wish. 

The point of trivial tree is to take off load from other maintainers 
(including Andrew) so that focusing on The Real Things is possible.

See relevant section of Documentation/SubmittingPatches.

But, as I said, I don't care that much. If you want to avoid trivial tree 
for some reason, feel free to do so.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
