Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab1EDA23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 20:28:29 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:34673 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754766Ab1EDA21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 20:28:27 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 May 2011 20:28:27 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=TiQeiJWTvKvpaNBFKmtwsF+lddCnib8Pvq6IvHwu25Hi7z4pwCXoYzixxn5VQh0EqjGKEdicQhoh+TRcfD1LyEzBKRR288+3jwwllHQUGH8BZRFXTm8GZzPqcVgWOq4R;
Date: Tue, 3 May 2011 17:21:41 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Dave Airlie <airlied@redhat.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC patch 25/32] trace event video gpu remove semicolons
Message-ID: <20110503172141.7d06fd7d@jbarnes-desktop>
In-Reply-To: <20110503231428.245701713@efficios.com>
References: <20110503231023.968960757@efficios.com>
	<20110503231428.245701713@efficios.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 May 2011 19:10:48 -0400
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
> of events, thus saving space for trace event probes.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Jesse Barnes <jbarnes@virtuousgeek.org>
> CC: Dave Airlie <airlied@redhat.com>
> CC: Chris Wilson <chris@chris-wilson.co.uk>
> CC: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  drivers/gpu/drm/drm_trace.h       |    6 ++--
>  drivers/gpu/drm/i915/i915_trace.h |   52 +++++++++++++++++++-------------------
>  2 files changed, 29 insertions(+), 29 deletions(-)
> 

Yeah, looks fine to me Mathieu, thanks.  I guess it should go in along
with the rest of your tracing fixes so the dependencies don't get
spread out across a bunch of different trees.

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
