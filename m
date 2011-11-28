Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab1K1Bps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 20:45:48 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54473 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab1K1Bpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 20:45:47 -0500
MIME-Version: 1.0
In-Reply-To: <1322439281.23348.34.camel@pasglop>
References: <1308875813-20122-1-git-send-email-wad@chromium.org>
	<1308875813-20122-11-git-send-email-wad@chromium.org>
	<1314682083.2488.73.camel@pasglop>
	<1322439281.23348.34.camel@pasglop>
Date: Sun, 27 Nov 2011 19:45:45 -0600
Message-ID: <CABqD9haiwc4zretJS2haYmGA0pY9vd1CSOAdhE_HsA7g7RaxSQ@mail.gmail.com>
Subject: Re: [PATCH v9 11/13] powerpc: select HAVE_SECCOMP_FILTER and provide seccomp_execve
From: Will Drewry <wad@chromium.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org, fweisbec@gmail.com, scarybeasts@gmail.com,
        djm@mindrot.org, linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        segoon@openwall.com, tglx@linutronix.de,
        Paul Mackerras <paulus@samba.org>, kees.cook@canonical.com,
        jmorris@namei.org, torvalds@linux-foundation.org, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 6:14 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Tue, 2011-08-30 at 15:28 +1000, Benjamin Herrenschmidt wrote:
>> On Thu, 2011-06-23 at 19:36 -0500, Will Drewry wrote:
>> > Facilitate the use of CONFIG_SECCOMP_FILTER by wrapping compatibility
>> > system call numbering for execve and selecting HAVE_SECCOMP_FILTER.
>> >
>> > v9: rebase on to bccaeafd7c117acee36e90d37c7e05c19be9e7bf
>> >
>> > Signed-off-by: Will Drewry <wad@chromium.org>
>>
>> Seen these around for a while ... :-)
>>
>> I don't see a harm in the patches per-se tho I haven't reviewed the
>> actual seccomp filter stuff and it's good (or bad) behaviour on ppc.
>
> Did that stuff every got anywhere ? I don't see HAVE_SECCOMP_FILTER
> upsteam ... should I just drop the powerpc patch from patchwork ?

Thanks for following up! At present, it stalled out, so I think it'd
make sense to just drop it.  I will repost the series soon-ish and see
if any progress can be made.  [I've explored a number of alternative
approaches and still think something along the seccomp_filter lines is
still rational.]

cheers!
will
