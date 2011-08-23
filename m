Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab1HWVp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 17:45:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752108Ab1HWVpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 17:45:20 -0400
Date: Tue, 23 Aug 2011 14:44:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: [PATCH] proc: fix races of /proc/PID/{fd/,fdinfo/,fdinfo/*}
Message-Id: <20110823144430.75315ce8.akpm@linux-foundation.org>
In-Reply-To: <20110804162009.GA2469@albatros>
References: <20110804162009.GA2469@albatros>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Aug 2011 20:20:09 +0400
Vasiliy Kulikov <segoon@openwall.com> wrote:

> fd* files are restricted to the task's owner, but keeping opened procfs
> file descriptors makes it possible to violate the permission model.
> Keeping fdinfo/* may disclosure current position and flags, keeping
> fdinfo/ and fd/ may disclosure number of opened files.
> 
> Used existing (un)lock_trace functions to deal with the race.

what race.

When fixing a bug, please completely, utterly and exhaustively describe
the bug!

> CC: Stable Tree <stable@kernel.org>

And when cc'ing -stable, please make it very clear why you consider the
bug sufficiently serious to warant mackporting the fix into earlier
kernels.

