Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab2GKLRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 07:17:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41405 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab2GKLRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 07:17:34 -0400
Date: Wed, 11 Jul 2012 13:17:28 +0200
From: Ingo Molnar <mingo@kernel.org>
To: John Stultz <johnstul@us.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [PATCH 0/6] Fix for leapsecond caused hrtimer/futex issue
 (updated)
Message-ID: <20120711111728.GA19242@gmail.com>
References: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <johnstul@us.ibm.com> wrote:

> Over the weekend, Thomas got a chance to review the leap 
> second fix in more detail and had a few additional changes he 
> wanted to make to improve performance as well as style.
> 
> So this iteration includes his modifications.

Yep, looks much saner now that the separate 'delayed' parameter 
is gone. For all patches:

Reviewed-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
