Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab0HaHcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 03:32:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:39202 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756552Ab0HaHcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 03:32:47 -0400
Date: Tue, 31 Aug 2010 09:32:37 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] idr: fix kernel-doc warnings.
In-Reply-To: <4C7BD3E1.2000806@kernel.org>
Message-ID: <alpine.LNX.2.00.1008310932300.1019@pobox.suse.cz>
References: <m27hj8cdsw.fsf@elisp.net> <4C7BD3E1.2000806@kernel.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Aug 2010, Tejun Heo wrote:

> > % perl scripts/kernel-doc lib/idr.c > /dev/null
> > Warning(lib/idr.c:300): No description found for parameter 'starting_id'
> > Warning(lib/idr.c:300): Excess function parameter 'start_id' description in 'idr_get_new_above'
> > Warning(lib/idr.c:485): No description found for parameter 'idp'
> > Warning(lib/idr.c:596): No description found for parameter 'nextidp'
> > Warning(lib/idr.c:596): Excess function parameter 'id' description in 'idr_get_next'
> > Warning(lib/idr.c:774): No description found for parameter 'starting_id'
> > Warning(lib/idr.c:774): Excess function parameter 'staring_id' description in 'ida_get_new_above'
> > Warning(lib/idr.c:918): No description found for parameter 'ida'
> > 
> > Signed-off-by: Naohiro Aota <naota@elisp.net>
> 
> Acked-by: Tejun Heo <tj@kernel.org>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
