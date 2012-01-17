Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab2AQXyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 18:54:15 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56462 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab2AQXyM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 18:54:12 -0500
MIME-Version: 1.0
In-Reply-To: <CACLa4pthnooQn8-kecPxHw7nVdHfx+0Vx5BpucLugMc9XN+dqg@mail.gmail.com>
References: <1326411506-16894-1-git-send-email-wad@chromium.org>
	<1326411506-16894-3-git-send-email-wad@chromium.org>
	<CACLa4pthnooQn8-kecPxHw7nVdHfx+0Vx5BpucLugMc9XN+dqg@mail.gmail.com>
Date: Tue, 17 Jan 2012 17:54:09 -0600
Message-ID: <CABqD9hasMJqDnXExcC4_mBPYC5qMv1VNrTS+AWvmkk9eKipGuQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] Documentation: prctl/seccomp_filter
From: Will Drewry <wad@chromium.org>
To: Eric Paris <eparis@parisplace.org>
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
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 5:29 PM, Eric Paris <eparis@parisplace.org> wrote:
> On Thu, Jan 12, 2012 at 6:38 PM, Will Drewry <wad@chromium.org> wrote:
>
>> +#ifndef PR_ATTACH_SECCOMP_FILTER
>> +#      define PR_ATTACH_SECCOMP_FILTER 36
>> +#endif
>
>
> The example code here uses 36, but the real code I believe uses 37.
> Can we get these in sync?  Thanks!

Nice - of course! [That is from before the PR_NO_NEW_PRIVS patch.]

thanks!
