Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab2AKUD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 15:03:56 -0500
Received: from tex.lwn.net ([70.33.254.29]:59923 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756695Ab2AKUDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 15:03:53 -0500
Date: Wed, 11 Jan 2012 13:03:49 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
Subject: Re: [RFC,PATCH 2/2] Documentation: prctl/seccomp_filter
Message-ID: <20120111130349.0dda72b3@dt>
In-Reply-To: <1326302710-9427-3-git-send-email-wad@chromium.org>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
	<1326302710-9427-3-git-send-email-wad@chromium.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interesting approach to the problem, I think I like it.  Watch for news at
11...:)

One nit:

> +Example
> +-------
> +
> +Assume a process would like to cleanly read and write to stdin/out/err and exit
> +cleanly.  Without using a BPF compiler, it may be done as follows on x86 32-bit:
> +

It seems like this little program belongs in the samples/ directory.

Thanks,

jon
