Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab1IGUjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 16:39:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755739Ab1IGUjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 16:39:47 -0400
Date: Wed, 7 Sep 2011 22:35:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Fix clearing of task->ptrace if PTRACE_SETOPTIONS
	fails
Message-ID: <20110907203540.GA20917@redhat.com>
References: <201109042311.18793.vda.linux@googlemail.com> <1315327963.29637.1.camel@dhcp-25-63.brq.redhat.com> <20110906184346.GA25904@redhat.com> <201109070645.00481.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109070645.00481.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07, Denys Vlasenko wrote:
>
> Fix clearing of task->ptrace if PTRACE_SETOPTIONS fails.
>
> If PTRACE_SETOPTIONS fails, options should not be affected.
> This patch makes it so.

Heh, OK. You won ;)

> While at it, simplify a few things:

No, no, Denys. Please make a separate patch which changes the
current behaviour, please. Then cleanups.

Otherwise looks correct.

Oleg.

