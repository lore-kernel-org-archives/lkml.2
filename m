Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240Ab1LNWBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 17:01:00 -0500
Received: from mail.openrapids.net ([64.15.138.104]:34220 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757366Ab1LNWA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 17:00:59 -0500
Date: Wed, 14 Dec 2011 17:00:57 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org
Subject: Re: [RELEASE] LTTng 2.0 prerelease bundle 20111213
Message-ID: <20111214220057.GA8794@Krystal>
References: <20111213233729.GA19576@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111213233729.GA19576@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:00:07 up 386 days,  3:03,  2 users,  load average: 0.14, 0.04,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update: prerelease bundle 20111214 updates lttng-ust to 1.9.2 which
adds missing files to the dist tarball.

Best regards,

Mathieu

* Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> LTTng, the Linux Trace Toolkit Next Generation, is a highly efficient
> full system tracing solution toolchain. It is composed of several
> components to allow tracing of the kernel, of userspace, trace viewing
> and analysis and trace streaming. LTTng is open source software.
> 
> New Features:
> 
> - Userspace Tracing Support. LTTng-UST is now available providing
>   application and library tracing with the same look and feel as for
>   LTTng kernel tracing.
> - LTTng 2.0 kernel modules build against a vanilla or distribution
>   kernel, without need for additional patches,
> - Tracepoints, detailed syscall tracing (fast strace replacement),
>   CPU Performance Monitoring Unit (PMU) counters, dynamic address/symbol
>   probing (kprobes) and function call/return tracing (kretprobes support),
> - Have the ability to attach "context" information to events in the
>   trace (e.g. any PMU counter, pid, ppid, tid, comm name, etc).
>   All the extra information fields to be collected with events are
>   optional, specified on a per-tracing-session basis (except for
>   timestamp and event id, which are mandatory).
> - Allows non-root users part of the "tracing" group to perform kernel
>   and userspace tracing.
> - Allows multiple tracing sessions to be active concurrently, each with
>   its own instrumentation set.
> - Integrated interface for both kernel and userspace tracing,
> - Produces CTF (Common Trace Format) natively,
>   (http://www.efficios.com/ctf)
> 
> You can get a the current release "bundle" (recommanded set of packages)
> at the following URL to get started:
> 
> http://lttng.org/bundles/
> 
> Please refer to the individual package changelogs for details on the
> recent changes.
> 
> Project website: http://lttng.org
> Download link: http://lttng.org/lttng2.0
> (please refer to the README files for installation instructions and
> lttng-tools doc/quickstart.txt for usage information)
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
