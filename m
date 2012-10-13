Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab2JMPWb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 11:22:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52047 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab2JMPWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 11:22:30 -0400
Date: Sat, 13 Oct 2012 17:22:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB v4
Message-ID: <20121013152223.GG16230@one.firstfloor.org>
References: <1349999637-8613-1-git-send-email-andi@firstfloor.org> <CAJd=RBByzsGUaOxOoQpu_SN+K5XRxd2PEGhB48CHkuO5qJ5grA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBByzsGUaOxOoQpu_SN+K5XRxd2PEGhB48CHkuO5qJ5grA@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > -                               struct user_struct **user, int creat_flags);
> > +                               struct user_struct **user, int creat_flags,
> > +                               int page_size_log);
> > +int hugetlb_get_quota(struct address_space *mapping, long delta);
> > +void hugetlb_put_quota(struct address_space *mapping, long delta);
> > +
> > +int hugetlb_get_quota(struct address_space *mapping, long delta);
> > +void hugetlb_put_quota(struct address_space *mapping, long delta);
> 
> 
> For what to add(twice) hugetlb_get/put_quota?

Hmm probably a merge error. Thanks for catching. 

I can repost or post the trivial incremential.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
