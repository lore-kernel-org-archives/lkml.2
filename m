Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab1BQPy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:54:56 -0500
Received: from cantor.suse.de ([195.135.220.2]:53078 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab1BQPyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:54:55 -0500
Date: Thu, 17 Feb 2011 16:54:52 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Ryota Ozaki <ozaki.ryota@gmail.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: Fix out-of-date comments which refers non-existent
 functions
In-Reply-To: <AANLkTikFEjeVJ2HY_KTv29y63bt_+8SwWm7K3Ywdw570@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1102171654400.2160@pobox.suse.cz>
References: <1297313788-10905-1-git-send-email-ozaki.ryota@gmail.com> <AANLkTikFEjeVJ2HY_KTv29y63bt_+8SwWm7K3Ywdw570@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Feb 2011, Minchan Kim wrote:

> > From: Ryota Ozaki <ozaki.ryota@gmail.com>
> >
> > do_file_page and do_no_page don't exist anymore, but some comments
> > still refers them. The patch fixes them by replacing them with
> > existing ones.
> >
> > Signed-off-by: Ryota Ozaki <ozaki.ryota@gmail.com>
> > Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Cc: Jiri Kosina <trivial@kernel.org>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

As it's not in linux-next, I have picked it up. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
