Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab2EGVzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 17:55:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51043 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab2EGVzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 17:55:22 -0400
Date: Mon, 7 May 2012 14:55:18 -0700
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep false positive in sysfs
Message-ID: <20120507215518.GN19417@google.com>
References: <20120507194658.GH19417@google.com>
 <Pine.LNX.4.44L0.1205071740420.23176-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1205071740420.23176-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 05:51:52PM -0400, Alan Stern wrote:
> I guess in the end it's a question of balance.  Which has more 
> overhead, adding a few function calls here and there, or adding a new 
> flags field to every struct attribute?

Yes, and there are different types of overheads.  I'm happy to trade
some runtime memory overhead under debugging mode for lower code
complexity.  Lock proving is pretty expensive anyway.  I don't think
there's much point in trying to optimize some bytes from struct
attributes.

Thanks.

-- 
tejun
