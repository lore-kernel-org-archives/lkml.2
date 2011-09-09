Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462Ab1IIQdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 12:33:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759451Ab1IIQdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 12:33:42 -0400
Date: Fri, 9 Sep 2011 18:30:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Pedro Alves <pedro@codesourcery.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH v3] Make PTRACE_SEIZE set ptrace options specified in
	'data'
Message-ID: <20110909163021.GD23271@redhat.com>
References: <1315506333.18043.49.camel@dhcp-25-63.brq.redhat.com> <201109091212.59889.pedro@codesourcery.com> <1315571337.4127.3.camel@dhcp-25-63.brq.redhat.com> <201109091415.33503.pedro@codesourcery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109091415.33503.pedro@codesourcery.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09, Pedro Alves wrote:
>
> Right, but we end up with no way to make the tracee _not ever
> stop_ at execve if the tracer wants to, like you can make
> the tracee not ever stop on forks or syscalls, by not enabling
> the corresponding PTRACE_O_FOO or not PTRACE_SYSCALL.  Not
> specifying PTRACE_O_TRACEEXEC coupled with `SEIZE not stopping
> tracees for that magic SIGTRAP' got you that.  In a way, it looked to
> me to make the API a bit less ugly.

Agreed, perhaps we should do this.

> Anyway, could you please check (or Tejun please confirm)
> that that magic SIGTRAP is really still there on SEIZE?

It is.

Oleg.

