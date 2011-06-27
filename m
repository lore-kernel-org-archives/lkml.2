Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753Ab1F0NiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 09:38:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759986Ab1F0NgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 09:36:15 -0400
Date: Mon, 27 Jun 2011 15:34:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: penguin-kernel@i-love.sakura.ne.jp
Cc: roland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: arch_ptrace_attach() without ptrace_traceme()?
Message-ID: <20110627133420.GA3527@redhat.com>
References: <201106270720.p5R7Kd9E095193@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106270720.p5R7Kd9E095193@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(add lkml)

On 06/27, penguin-kernel@i-love.sakura.ne.jp wrote:
>
> Regarding commit f1671f6d "ptrace: fix exit_ptrace() vs ptrace_traceme() race",
> is calling arch_ptrace_attach() when ptrace_traceme() returned 0 without doing
> anything (due to PF_EXITING race) expected behavior?

Hmm. Good point, I thinks this should be fixed.

Thanks!

Oleg.

