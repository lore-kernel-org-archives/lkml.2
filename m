Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab2BQWm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 17:42:56 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57476 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab2BQWmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 17:42:55 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.244.37 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Fri, 17 Feb 2012 14:42:50 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH 7/9] block: implement bio_associate_current()
Message-ID: <20120217224250.GO29414@google.com>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
 <1329431878-28300-8-git-send-email-tj@kernel.org>
 <20120217213313.GG26620@redhat.com>
 <20120217220351.GI29414@google.com>
 <20120217222909.GI26620@redhat.com>
 <20120217223859.GM29414@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217223859.GM29414@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 02:38:59PM -0800, Tejun Heo wrote:
> At first, it required the locking update because I was determining
> blkg association on bio issue and then passing it down.  That didn't
> work with cfq caching the association, so it no longer has dependency.
> It should can be a separate patchset.  This whole lot is gonna go in
> as long sequential series of patches so I'm splitting them just so
> that each posting isn't too huge at this point.

Hmmm... I'll move the two locking patches to the previous series and
let this series handle just the stacking issue.

Thanks.

-- 
tejun
