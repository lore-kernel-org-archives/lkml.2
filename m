Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab1FCPjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:39:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab1FCPjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:39:16 -0400
Date: Fri, 3 Jun 2011 17:37:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and
	group stop notification, take#4
Message-ID: <20110603153734.GC23757@redhat.com>
References: <1306710760-16440-1-git-send-email-tj@kernel.org> <20110602123105.GD10410@mtj.dyndns.org> <20110602182744.GA21705@redhat.com> <201106022309.44663.vda.linux@googlemail.com> <20110603013423.GB14872@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110603013423.GB14872@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03, Tejun Heo wrote:
>
> Okay, you want to preserve %NULL SIGINFO on all STOP traps.  Dropping
> si_pt_flags and using exit_code makes sense but I think we'll be
> better off enabling GETSIGINFO.

Agreed. I do not see why GETSIGINFO should fail.

Oleg.

