Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab2ALNNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 08:13:11 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61112 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab2ALNNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 08:13:07 -0500
Message-ID: <4F0EDC5C.3040001@gmail.com>
Date: Thu, 12 Jan 2012 14:13:00 +0100
From: =?UTF-8?B?xYF1a2FzeiBTb3dh?= <luksow@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111224 Thunderbird/9.0.1
MIME-Version: 1.0
To: Will Drewry <wad@chromium.org>
CC: linux-kernel@vger.kernel.org, keescook@chromium.org,
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
References: <1326302710-9427-1-git-send-email-wad@chromium.org> <1326302710-9427-3-git-send-email-wad@chromium.org>
In-Reply-To: <1326302710-9427-3-git-send-email-wad@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

That's very different approach to the system call interposition problem.
I find you solution very interesting. It gives far more capabilities
than my syscalls cgroup that you commented on some time ago. It's ready
now but I haven't tried filtering yet. I think that if your solution
make it to the mainline (and I guess that's really possible at current
stage :)), there will be no place for mine solution but that's ok.

There's one thing that I'm curious about - have you measured overhead in
any way? That was one of the biggest issues in all previous attempts to
limit syscalls. I'd love to compare the numbers with mine solution.

I'll examine your patch later on and put some comments if I bump into
something.

Best Regards,
Lukasz Sowa

