Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab2GTTlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 15:41:21 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39872 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab2GTTlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 15:41:19 -0400
Date: Fri, 20 Jul 2012 12:41:14 -0700
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-pm@vger.kernel.org
Subject: Re: [PATCHSET] workqueue: reimplement CPU hotplug to keep idle
 workers
Message-ID: <20120720194114.GA21218@google.com>
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
 <1342808550.2583.48.camel@twins>
 <20120720183400.GL32763@google.com>
 <201207202144.05154.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207202144.05154.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

On Fri, Jul 20, 2012 at 09:44:04PM +0200, Rafael J. Wysocki wrote:
> Well, there are use cases I'm not really familiar with.
> 
> Pretty much the only use case I'm sufficiently familiar with is
> suspend/hibernate where we unplug all of the nonboot CPUs at one point.
> 
> The other use cases, which I don't really think are entirely valid,
> are on some ARM platforms where CPUs are unplugged instead of being put into
> C-states or equivalent (because we don't have a good mechanism for handling
> multiprocessor C-states; there's a set of patches for that waiting for
> the merge window in the Len's tree).  I'm hoping to get rid of those
> use cases in future entirely.

I see, so the highest frequency user would most likely be
suspend/resume - especially with opportunistic approach like the one
used in androids.

Thanks for the explanation.

-- 
tejun
