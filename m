Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab1IIPbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 11:31:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543Ab1IIPbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 11:31:48 -0400
Date: Fri, 9 Sep 2011 17:28:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        dvlasenk@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/2] Fixes and cleanups in PTRACE_SETOPTIONS
Message-ID: <20110909152800.GA21892@redhat.com>
References: <201109090822.30063.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109090822.30063.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09, Denys Vlasenko wrote:
>
> This patchset has two changes.
>
> First patch makes ptrace(PTRACE_SETOPTIONS, pid, 0, <bogus value>)
> to error out *without* changing any task->ptrace bits.
>
> Second patch is a cleanup: PTRACE_SETOPTIONS code
> clears all option bits in task->ptrace, then sets bits one-by-one.
> This is butt-ugly.

OK, thanks.

I'll wait a bit to collect the possible acks, and apply.

Oleg.

