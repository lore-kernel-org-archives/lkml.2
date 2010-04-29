Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349Ab0D3SZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:25:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933175Ab0D3RWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:22:24 -0400
Date: Thu, 29 Apr 2010 21:44:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <len.brown@intel.com>
Subject: [PATCH 0/2] workqueue fixlets (Was: PM: Add suspend blocking work.)
Message-ID: <20100429194447.GA17280@redhat.com>
References: <1272429119-12103-1-git-send-email-arve@android.com> <20100428194028.GA16389@redhat.com> <4BD89922.1040306@kernel.org> <201004282308.10751.rjw@sisk.pl> <20100429185851.GA13862@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100429185851.GA13862@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29, Oleg Nesterov wrote:
>
> I don't really care, this change is trivial. But to me it makes more
> sense to push the trivial/simple changes ahead. Unless they really
> complicate the maintainging of the pending cmwq changes.
>
> Hmm... Speaking about keventd_wq, I just noticed flush_delayed_work()
> needs the fix:

So. I'd suggestd these 2 simple patches for now.

Please note that 2/2 is really trivial, it only adds EXPORT_SYMBOL but
avoids the possible cleanups to minimize the conflicts with the pending
cmwq changes. However, please feel free to ignore this patch.

As for 1/2, imho it is always better to fix the bug asap, even if it is
minor.

Oleg.

