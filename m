Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176Ab2HJJOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 05:14:46 -0400
Received: from tundra.namei.org ([65.99.196.166]:54388 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131Ab2HJJOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 05:14:42 -0400
Date: Fri, 10 Aug 2012 19:14:32 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Will Drewry <wad@chromium.org>
cc: Andrew Lutomirski <luto@mit.edu>, Kees Cook <keescook@chromium.org>,
        james.l.morris@oracle.com, rob@landley.net, linux-doc@vger.kernel.org,
        cevans@chromium.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, eparis@redhat.com, fengxj325@gmail.com
Subject: Re: [PATCH 2/3] vsyscall_64: allow SECCOMP_RET_TRACErs to skip
In-Reply-To: <CABqD9hYoVNo34oqGh7mCmGZF7nKDC3-d2LD=BLhEUJtM7GbFvQ@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1208101913160.14083@tundra.namei.org>
References: <1342279974-26917-1-git-send-email-wad@chromium.org> <1342279974-26917-2-git-send-email-wad@chromium.org> <CAObL_7GX0q_qywY4g1S2iRZWPS95ar01wtvv9wDW=zswwaZ6fQ@mail.gmail.com> <CABqD9hbmsi-VcXATWsGw37vo2RxoMvFvUs-RkVx9nTGbPtqidg@mail.gmail.com>
 <CABqD9hYz3410CE7cwfzw7zAXD3k2kT2PNfSmFLiaf+sbRTnfmQ@mail.gmail.com> <CAObL_7EQH6KQCU-iWOt9SKn49p2K3n3GV1QS4ZDvnjhhLyXCeA@mail.gmail.com> <CAObL_7HDQVmLxpU4YH66uFPHD_ZmK02DwCXZHuzO9EY9eP07zA@mail.gmail.com>
 <CABqD9hYoVNo34oqGh7mCmGZF7nKDC3-d2LD=BLhEUJtM7GbFvQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jul 2012, Will Drewry wrote:

> Agreed :) I don't mind making tweaks to get it right, but this only
> matters to users that want to:
> - use seccomp filter
> - with ptrace (or trap with resumption and not sigreturn)
> - of time, gettimeofday, and getcpu
> since they will then have to include quirk management _just_ in case
> their code is linked against something using vsyscall and
> vsyscall=emulate is in effect!

I think these patches came out during the merge window -- is there any 
further discussion on them?


- James
-- 
James Morris
<jmorris@namei.org>
