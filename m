Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab2LKV6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 16:58:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531Ab2LKV6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 16:58:53 -0500
Message-ID: <1355263123.3527.27.camel@localhost>
Subject: Re: linux-next: recent rebases
From: Eric Paris <eparis@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kees Cook <keescook@google.com>
Date: Tue, 11 Dec 2012 16:58:43 -0500
In-Reply-To: <20121212084108.de14154ec0e365453617bfd7@canb.auug.org.au>
References: <20121212084108.de14154ec0e365453617bfd7@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-12 at 08:41 +1100, Stephen Rothwell wrote:
> Hi Linus,
> 
> I am not sure how much you care about this, but here is a list of the
> trees in linux-next that have been rebased in the last day (i.e. since I
> fetched the trees for next-20121211):
> 
> fsnotify: rebased to v3.6(!) to resolve a conflict.
> 	git://git.infradead.org/users/eparis/notify.git#for-next

I planned to let it sit in -next until at least next thursday before I
sent a pull request.  Thought that fit within the rules...

