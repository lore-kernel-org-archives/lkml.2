Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab2AMAhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 19:37:17 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:56090 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756405Ab2AMAhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 19:37:13 -0500
Message-ID: <4F0F8A52.80205@xenotime.net>
Date: Thu, 12 Jan 2012 17:35:14 -0800
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
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH v3 2/3] seccomp_filters: system call filtering using BPF
References: <1326411506-16894-1-git-send-email-wad@chromium.org>	<1326411506-16894-2-git-send-email-wad@chromium.org>	<4F0F8029.9030508@xenotime.net> <CABqD9hZtOGa72RVsaur-t+UJRN0sd92Vj8yZDsu1FsPK7jQbGg@mail.gmail.com>
In-Reply-To: <CABqD9hZtOGa72RVsaur-t+UJRN0sd92Vj8yZDsu1FsPK7jQbGg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2012 03:59 PM, Will Drewry wrote:
>>> diff --git a/kernel/seccomp_filter.c b/kernel/seccomp_filter.c
>>> new file mode 100644
>>> index 0000000..108a3f3
>>> --- /dev/null
>>> +++ b/kernel/seccomp_filter.c
>>> @@ -0,0 +1,620 @@
>>> +/* bpf program-based system call filtering
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License as published by
>>> + * the Free Software Foundation; either version 2 of the License, or
>>> + * (at your option) any later version.
>>> + *
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> + * GNU General Public License for more details.
>>> + *
>>> + * You should have received a copy of the GNU General Public License
>>> + * along with this program; if not, write to the Free Software
>>> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
>>> + *
>>> + * Copyright (C) 2011 The Chromium OS Authors <chromium-os-dev@chromium.org>
>>> + */
>>> +
> 
> Aside from being a year off, is there a current style?  I just went
> off of an existing file.

Sorry, I wasn't making a comment about that header.  Guess I should
have deleted it.

thanks,
-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
