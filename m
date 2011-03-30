Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab1C3Xdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 19:33:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59389 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab1C3Xd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 19:33:29 -0400
Date: Thu, 31 Mar 2011 01:33:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Andi Kleen <andi@firstfloor.org>, mijinlong@cn.fujitsu.com,
        ak@linux.intel.com, bfields@redhat.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: Re: [PATCH] [232/275] nfsd: wrong index used in inner loop
Message-ID: <20110330233328.GH21838@one.firstfloor.org>
References: <20110330203.501921634@firstfloor.org> <20110330210757.F3D223E1A05@tassilo.jf.intel.com> <4D93A6F4.60206@msgid.tls.msk.ru> <4D93A8F9.2080407@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D93A8F9.2080407@msgid.tls.msk.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Doh, so this 232/275 basically reverts that 180 and makes
> other change down the line, but keeps the subject intact.
> Especially useful that the two patches are so far away
> from each other (more than 50 patches in-between).
> Confusing :)
> 
> So both are actually needed, apparently.

Sorry about that -- i ended up grabbing those from .32 and since
there were multiple releases in sequence it ended up this way.

I can collapse the two patches.

Are the leftover hunks after that good?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
