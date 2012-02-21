Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab2BURmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 12:42:09 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:37498 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab2BURmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:42:07 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of fweisbec@gmail.com designates 10.229.134.196 as permitted sender) smtp.mail=fweisbec@gmail.com; dkim=pass header.i=fweisbec@gmail.com
Date: Tue, 21 Feb 2012 18:42:03 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Mandeep Singh Baines <msb@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 0/2] cgroup: Fix some races against css_set task
 links
Message-ID: <20120221174200.GB13403@somewhere.redhat.com>
References: <1328668647-24125-1-git-send-email-fweisbec@gmail.com>
 <4F3DE881.6090503@cn.fujitsu.com>
 <20120221171621.GB12236@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120221171621.GB12236@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 09:16:21AM -0800, Tejun Heo wrote:
> Hello, Frederic, Li.
> 
> Sorry about the delay.  I was (and still is) swamped with block cgroup
> stuff.
> 
> As the patch is low risk and fix for a race condition, I applied it to
> for-3.3-fixes.  Will push to Linus in a week or so.

IMHO since this doesn't really fix a regression (I guess) I suspect this
should go for 3.4 to avoid any surprise like some missed lock inversion.

But I'll let you choose.

> 
> Thanks.
> 
> -- 
> tejun
