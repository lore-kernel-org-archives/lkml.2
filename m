Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab0IOO5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 10:57:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58117 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392Ab0IOO5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 10:57:39 -0400
Date: Wed, 15 Sep 2010 16:57:36 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        lkml <linux-kernel@vger.kernel.org>, Naohiro Aota <naota@elisp.net>
Subject: Re: [PATCH] docbook: add idr/ida to kernel-api docbook
In-Reply-To: <4C908047.404@kernel.org>
Message-ID: <alpine.LNX.2.00.1009151657080.26813@pobox.suse.cz>
References: <20100914150851.f5ae1da2.randy.dunlap@oracle.com> <4C908047.404@kernel.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010, Tejun Heo wrote:

> On 09/15/2010 12:08 AM, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Add idr/ida to kernel-api docbook.
> > Fix typos and kernel-doc notation.
> > 
> > Includes idr patches from Naohiro Aota <naota@elisp.net> (for
> > completeness only; will wait for those to be merged via the trivial tree).
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Naohiro Aota <naota@elisp.net>
> > Cc: Jiri Kosina <jkosina@suse.cz>
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> Thank you.

What is this based on? As it doesn't apply on top of current Linus' tree, 
I will probably not be taking it throgh trivial queue, ok?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
