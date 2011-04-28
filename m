Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760573Ab1D1O3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 10:29:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54252 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760497Ab1D1O3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 10:29:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OGxRl/0b0ZLJx/ARgwmXHj1tNDyJJ10XO6DcUYBsw7DJqIEvSfx87NnHgvTTL1Sgk+
         moJrQjRSCVn1GWM1BwIZGaWcJL2BvxBc0JHoE8hqnwlAqRfXsV4nrueBLDd7xMm7hl7k
         hl1daVa+z7GgZjn1uc9OP8Esu3QzvKrUfvhmE=
Date: Thu, 28 Apr 2011 16:29:00 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, kees.cook@canonical.com, eparis@redhat.com,
        agl@chromium.org, mingo@elte.hu, jmorris@namei.org,
        rostedt@goodmis.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Slaby <jslaby@suse.cz>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 3/7] seccomp_filter: Enable ftrace-based system call
 filtering
Message-ID: <20110428142857.GC1798@nowhere>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
 <1303960136-14298-2-git-send-email-wad@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303960136-14298-2-git-send-email-wad@chromium.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 10:08:47PM -0500, Will Drewry wrote:
> This change adds a new seccomp mode based on the work by
> agl@chromium.org. This mode comes with a bitmask of NR_syscalls size and
> an optional linked list of seccomp_filter objects. When in mode 2, all

Since you now use the filters. Why not using them to filter syscalls
entirely rather than using a bitmap of allowed syscalls?

You have the "nr" field in syscall tracepoints.
