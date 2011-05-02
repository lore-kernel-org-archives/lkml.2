Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab1EBKIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 06:08:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46561 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab1EBKIY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 06:08:24 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1104290853280.26322@tundra.namei.org>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
	<1303960136-14298-3-git-send-email-wad@chromium.org>
	<20110428122334.D197.A69D9226@jp.fujitsu.com>
	<BANLkTinfXZ3j0vG51=cQjM0FZQ5VR5ze8A@mail.gmail.com>
	<alpine.LRH.2.00.1104290853280.26322@tundra.namei.org>
Date: Mon, 2 May 2011 03:08:23 -0700
Message-ID: <BANLkTi=GA1iFFOirGaG3Th_qOexnAcphOA@mail.gmail.com>
Subject: Re: [PATCH 4/7] seccomp_filter: add process state reporting
From: Will Drewry <wad@chromium.org>
To: James Morris <jmorris@namei.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        eparis@redhat.com, agl@chromium.org, mingo@elte.hu,
        rostedt@goodmis.org, Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 3:54 PM, James Morris <jmorris@namei.org> wrote:
> On Wed, 27 Apr 2011, Will Drewry wrote:
>
>> > Can't you make individual seccomp specific file?
>>
>> Definitely.  Would it make sense to have /proc/<pid>/seccomp and
>> /proc/<pid>/seccomp_filter?
>
> Do you need the separate seccomp file vs. just checking what's in
> seccomp_filter ?

Initially, I would've said yes, because I had modeled it such that any
entries in /proc/<pid>/seccomp_filter could be fed right back into as
filters.  However, as I've reworked it from Frederic and other's
feedback, I don't need to keep the separation - all the relevant info
can just be in seccomp_filter and no secondary file will be useful.

Thanks for pointing it out!  I'm tracking down what is, no doubt, a
dumb bug (still), but once I sort it, I'll repost the series with this
change included.

Cheers!
will
