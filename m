Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab0LVMXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 07:23:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818Ab0LVMXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 07:23:40 -0500
Date: Wed, 22 Dec 2010 13:16:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 14/16] ptrace: make SIGCONT notification reliable
	against ptrace
Message-ID: <20101222121621.GA1020@redhat.com>
References: <1291654624-6230-1-git-send-email-tj@kernel.org> <1291654624-6230-15-git-send-email-tj@kernel.org> <20101220194354.GA23281@redhat.com> <20101221174849.GI13285@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101221174849.GI13285@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21, Tejun Heo wrote:
>
> but do you in general agree with
> where it's headed?

Absolutely.

Except. I am not sure we understand the desired behaviour for
CLD_CONTINUED. To the point, perhaps the debugger does not
need it at all?


Again, I'll try to summarize my questions later today.

Oleg.

