Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab0ESH6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 03:58:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63837 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab0ESH6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 03:58:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UzM5y9GXFPRPSoEziBKzrJ/sjqASlMBhptgd0q0JvlJP3MMEgiuxxn8fSzoMqPUshM
         Onqy/vKk5rr1Lh7kuofm32gascQP59icGOKRmk7YBif5EyZqbSISgzOPm9fqhcuGMuXh
         7NJxvlEU07cSM78TRgUMX66NmPF6gO/a5Qluc=
Date: Wed, 19 May 2010 09:58:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/ftrace: Optimize perf/tracepoint
	interaction for single events
Message-ID: <20100519075804.GF5704@nowhere>
References: <tip-4f41c013f553957765902fb01475972f0af3e8e7@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-4f41c013f553957765902fb01475972f0af3e8e7@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 05:15:42PM +0000, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  4f41c013f553957765902fb01475972f0af3e8e7
> Gitweb:     http://git.kernel.org/tip/4f41c013f553957765902fb01475972f0af3e8e7
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Tue, 18 May 2010 18:08:32 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 18 May 2010 18:35:46 +0200
> 
> perf/ftrace: Optimize perf/tracepoint interaction for single events
> 
> When we've got but a single event per tracepoint
> there is no reason to try and multiplex it so don't.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Tested-by: Ingo Molnar <mingo@elte.hu>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> LKML-Reference: <new-submission>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---


I haven't seen this patch going.

But yeah that's a nice optimization for UP machines.

