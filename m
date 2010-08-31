Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908Ab0HaHoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 03:44:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:39469 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756096Ab0HaHoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 03:44:19 -0400
Date: Tue, 31 Aug 2010 09:44:17 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] idr: describe how nextidp works in idr_get_next().
In-Reply-To: <4C7CB237.6090606@kernel.org>
Message-ID: <alpine.LNX.2.00.1008310944060.1019@pobox.suse.cz>
References: <m27hj8cdsw.fsf@elisp.net> <m2pqx0az4h.fsf@elisp.net> <4C7BD45B.3050300@kernel.org> <m2bp8jbf9q.fsf@elisp.net> <4C7CB237.6090606@kernel.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Aug 2010, Tejun Heo wrote:

> > From: Naohiro Aota <naota@elisp.net>
> > Date: Fri, 27 Aug 2010 17:43:46 +0900
> > Subject: [PATCH 2/2] idr: describe how nextidp works in idr_get_next().
> > 
> > It was unclear in original kernel-doc how nextidp worked in
> > idr_get_next(). Let's describe it.
> > 
> > Signed-off-by: Naohiro Aota <naota@elisp.net>
> 
> Acked-by: Tejun Heo <tj@kernel.org>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
