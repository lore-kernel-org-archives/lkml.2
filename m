Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab2ALRX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 12:23:58 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51254 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab2ALRXz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 12:23:55 -0500
MIME-Version: 1.0
In-Reply-To: <4F0F238E.7020508@xenotime.net>
References: <CABqD9hbQRinbYqqwjqH8TfDvkOpESwiCp1uEE8d0Q7Rp4tsM0A@mail.gmail.com>
	<1326323983-23630-1-git-send-email-wad@chromium.org>
	<4F0F238E.7020508@xenotime.net>
Date: Thu, 12 Jan 2012 11:23:53 -0600
Message-ID: <CABqD9haEB8OFxKht0u7hiHoQf+_xZL=Y8nFYKUb6DxonR9w6UQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] Documentation: prctl/seccomp_filter
From: Will Drewry <wad@chromium.org>
To: Randy Dunlap <rdunlap@xenotime.net>
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
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 12:16 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 01/11/2012 03:19 PM, Will Drewry wrote:
>> Document how system call filtering with BPF works and
>> may be used.  Includes an example for x86 (32-bit).
>
> Please tell some of us what "BPF" means.  wikipedia lists 15 possible
> choices, but I don't know which one to choose.

I'll make it clearer in the documentation file and update the patch description.

BPF == Berkeley Packet Filters which are implemented in Linux Socket
Filters (LSF)>

thanks!

>> Signed-off-by: Will Drewry <wad@chromium.org>
>> ---
>>  Documentation/prctl/seccomp_filter.txt |   99 ++++++++++++++++++++++++++++++++
>>  samples/Makefile                       |    2 +-
>>  samples/seccomp/Makefile               |   12 ++++
>>  samples/seccomp/bpf-example.c          |   74 ++++++++++++++++++++++++
>>  4 files changed, 186 insertions(+), 1 deletions(-)
>>  create mode 100644 Documentation/prctl/seccomp_filter.txt
>>  create mode 100644 samples/seccomp/Makefile
>>  create mode 100644 samples/seccomp/bpf-example.c
>
>
> --
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
