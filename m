Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab2HMSRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 14:17:42 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59601 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab2HMSRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 14:17:38 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1208101913160.14083@tundra.namei.org>
References: <1342279974-26917-1-git-send-email-wad@chromium.org>
 <1342279974-26917-2-git-send-email-wad@chromium.org> <CAObL_7GX0q_qywY4g1S2iRZWPS95ar01wtvv9wDW=zswwaZ6fQ@mail.gmail.com>
 <CABqD9hbmsi-VcXATWsGw37vo2RxoMvFvUs-RkVx9nTGbPtqidg@mail.gmail.com>
 <CABqD9hYz3410CE7cwfzw7zAXD3k2kT2PNfSmFLiaf+sbRTnfmQ@mail.gmail.com>
 <CAObL_7EQH6KQCU-iWOt9SKn49p2K3n3GV1QS4ZDvnjhhLyXCeA@mail.gmail.com>
 <CAObL_7HDQVmLxpU4YH66uFPHD_ZmK02DwCXZHuzO9EY9eP07zA@mail.gmail.com>
 <CABqD9hYoVNo34oqGh7mCmGZF7nKDC3-d2LD=BLhEUJtM7GbFvQ@mail.gmail.com> <alpine.LRH.2.02.1208101913160.14083@tundra.namei.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 13 Aug 2012 11:17:17 -0700
X-Google-Sender-Auth: DagBwlTu8OJPMZghv_biVTxnnQw
Message-ID: <CAObL_7EuKc1-gYCeaB=o1DypwEeTqMDxXSg5iXfPYXTYVU1_DQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] vsyscall_64: allow SECCOMP_RET_TRACErs to skip
To: James Morris <jmorris@namei.org>
Cc: Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>,
        james.l.morris@oracle.com, rob@landley.net, linux-doc@vger.kernel.org,
        cevans@chromium.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, eparis@redhat.com, fengxj325@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 2:14 AM, James Morris <jmorris@namei.org> wrote:
> On Sat, 14 Jul 2012, Will Drewry wrote:
>
>> Agreed :) I don't mind making tweaks to get it right, but this only
>> matters to users that want to:
>> - use seccomp filter
>> - with ptrace (or trap with resumption and not sigreturn)
>> - of time, gettimeofday, and getcpu
>> since they will then have to include quirk management _just_ in case
>> their code is linked against something using vsyscall and
>> vsyscall=emulate is in effect!
>
> I think these patches came out during the merge window -- is there any
> further discussion on them?

The patch I sent on Aug 1 is the latest version.  I don't think
there's been any further discussion -- everyone seems reasonably happy
with that version.

--Andy

>
>
> - James
> --
> James Morris
> <jmorris@namei.org>
