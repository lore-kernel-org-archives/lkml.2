Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab2ALRSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 12:18:49 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:60573 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754089Ab2ALRSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 12:18:47 -0500
Message-ID: <4F0F238E.7020508@xenotime.net>
Date: Thu, 12 Jan 2012 10:16:46 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
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
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net
Subject: Re: [PATCH v2 2/2] Documentation: prctl/seccomp_filter
References: <CABqD9hbQRinbYqqwjqH8TfDvkOpESwiCp1uEE8d0Q7Rp4tsM0A@mail.gmail.com> <1326323983-23630-1-git-send-email-wad@chromium.org>
In-Reply-To: <1326323983-23630-1-git-send-email-wad@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2012 03:19 PM, Will Drewry wrote:
> Document how system call filtering with BPF works and
> may be used.  Includes an example for x86 (32-bit).

Please tell some of us what "BPF" means.  wikipedia lists 15 possible
choices, but I don't know which one to choose.

> Signed-off-by: Will Drewry <wad@chromium.org>
> ---
>  Documentation/prctl/seccomp_filter.txt |   99 ++++++++++++++++++++++++++++++++
>  samples/Makefile                       |    2 +-
>  samples/seccomp/Makefile               |   12 ++++
>  samples/seccomp/bpf-example.c          |   74 ++++++++++++++++++++++++
>  4 files changed, 186 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/prctl/seccomp_filter.txt
>  create mode 100644 samples/seccomp/Makefile
>  create mode 100644 samples/seccomp/bpf-example.c


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
