Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab0LVXCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 18:02:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751394Ab0LVXCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 18:02:36 -0500
Date: Wed, 22 Dec 2010 15:02:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Dan Carpenter <error27@gmail.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC Patch] kcore: restrict access to the whole memory
Message-Id: <20101222150209.8e18afa7.akpm@linux-foundation.org>
In-Reply-To: <1293016926-1714-1-git-send-email-amwang@redhat.com>
References: <1293016926-1714-1-git-send-email-amwang@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Dec 2010 19:21:59 +0800
Amerigo Wang <amwang@redhat.com> wrote:

> This patch restricts /proc/kcore from accessing the whole memory,
> instead, only an ELF header can be read.
> 
> The initial patch was done by Vivek.

Getting a bit tired of this.

Are we supposed to be mind-readers?  How else are we to work out why
you think Linux needs this feature?  What problems it solves?  What
applications are expected to break and what the breakage patterns are? 
Why the benefits are worth the maintenance costs and the risk of
breakage?  Why it's done with a config option and not a boot-time or
runtime tunable?

c'mon, you guys have been around long enough to understand this stuff.
