Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab2A1LWs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 06:22:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605Ab2A1LWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 06:22:45 -0500
Message-ID: <1327749669.15441.9.camel@cr0>
Subject: Re: [PATCH v5 2/3] seccomp_filters: system call filtering using BPF
From: Cong Wang <amwang@redhat.com>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com, corbet@lwn.net,
        alan@lxorguk.ukuu.org.uk, indan@nul.nu, mcgrathr@chromium.org
Date: Sat, 28 Jan 2012 19:21:09 +0800
In-Reply-To: <1327706681-11959-2-git-send-email-wad@chromium.org>
References: <1327706681-11959-1-git-send-email-wad@chromium.org>
	 <1327706681-11959-2-git-send-email-wad@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-27 at 17:24 -0600, Will Drewry wrote:
> +config SECCOMP_FILTER
> +       bool "Enable seccomp-based system call filtering"
> +       select SECCOMP

Is 'depends on SECCOMP' better?

> +       help
> +         This option provide support for limiting the accessibility
> of

s/provide/provides/

> +         systems calls at a task-level using a dynamically defined
> policy.


s/systems/system/

> +
> +         System call filtering policy is expressed by the user using
> +         a Berkeley Packet Filter program.  The program is attached
> using

s/the user using//

> +         prctl(2).  For every system call the task makes, its number,
> +         arguments, and other metadata will be evaluated by the
> attached
> +         filter program.  The result determines if the system call
> may
> +         may proceed or if the task should be terminated.

One more "may"... and "be proceeded"

> +
> +         This behavior is meant to aid security-conscious software in
> +         its ability to minimize the risk of running potentially
> +         risky code.
> +
> +         See Documentation/prctl/seccomp_filter.txt for more detail.
> + 


Thanks.

