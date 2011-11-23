Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab1KWRbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 12:31:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab1KWRbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 12:31:39 -0500
Date: Wed, 23 Nov 2011 18:26:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Pedro Alves <pedro@codesourcery.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Roland McGrath <roland@hack.frob.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with
	given pids
Message-ID: <20111123172636.GA25100@redhat.com>
References: <4EC4F2FB.408@parallels.com> <201111221204.39235.pedro@codesourcery.com> <20111122153326.GD322@google.com> <201111231620.45440.pedro@codesourcery.com> <20111123162417.GE25780@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123162417.GE25780@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23, Tejun Heo wrote:
>
> I see.  So, let's do it for root for now and later add finer grained
> CAP as necessary/viable.

Agreed.

Stupid off-topic question, I am just curious... Why /proc/sys
dislikes chmod ? I do not understand this code, but it seems
that it would be simple to change proc_sys_setattr() to respect
ATTR_MODE and update PROC_I(inode)->sysctl_entry->mode, no?

> Pavel, what do you think?

Yes...

Oleg.

