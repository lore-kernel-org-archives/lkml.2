Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab1DZTtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:49:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756252Ab1DZTtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:49:49 -0400
Date: Tue, 26 Apr 2011 21:48:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] sigtimedwait/sigprocmask need
	retarget_shared_pending()
Message-ID: <20110426194822.GA8520@redhat.com>
References: <20110418134421.GA15951@redhat.com> <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com> <20110418173224.GA27918@redhat.com> <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com> <20110423175901.GA484@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110423175901.GA484@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes:

	1/6: remove the evidence of my ignorance from the changelog,
	     += (tv_sec || tv_nsec) is correct

	2/6: more factorization, rename the argument, add the comment
	     from Linus.

	     please re-add the acks.

	3/6: fix the typos in the changelog, thanks Matt

	4-6: new.	

I really hope that this is the last "nontrivial" changes in this area
which need any discussion, everything else looks simple.

Oleg.

