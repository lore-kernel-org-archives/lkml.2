Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934344Ab2GMBrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 21:47:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36520 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab2GMBrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 21:47:51 -0400
Date: Thu, 12 Jul 2012 22:47:46 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Laurent Chavey <chavey@google.com>,
        Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [ 54/68] tracing: change CPU ring buffer state from
 tracing_cpumask
Message-ID: <20120713014745.GC3121@herton-Z68MA-D2H-B3>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
 <20120712175040.215945708@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120712175040.215945708@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 04:02:28PM -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
> 
> 3.0-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Vaibhav Nagarnaik <vnagarnaik@google.com>
> 
> commit 71babb2705e2203a64c27ede13ae3508a0d2c16c upstream.
> 
> According to Documentation/trace/ftrace.txt:
> 
> tracing_cpumask:
> 
>         This is a mask that lets the user only trace
>         on specified CPUS. The format is a hex string
>         representing the CPUS.
> 
> The tracing_cpumask currently doesn't affect the tracing state of
> per-CPU ring buffers.
> 
> This patch enables/disables CPU recording as its corresponding bit in
> tracing_cpumask is set/unset.
> 
> Link: http://lkml.kernel.org/r/1336096792-25373-3-git-send-email-vnagarnaik@google.com

Missing patch.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
[]'s
Herton
