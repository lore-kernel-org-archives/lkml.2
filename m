Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab2IVHTr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 03:19:47 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48428 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab2IVHTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 03:19:45 -0400
Message-ID: <505D668C.7010206@suse.cz>
Date: Sat, 22 Sep 2012 09:19:40 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0a2
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Michel Lespinasse <walken@google.com>,
        Sasha Levin <levinsasha928@gmail.com>, linux-mm@kvack.org,
        riel@redhat.com, peterz@infradead.org, aarcange@redhat.com,
        daniel.santos@pobox.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 6/7] mm: add CONFIG_DEBUG_VM_RB build option
References: <1346750457-12385-1-git-send-email-walken@google.com> <1346750457-12385-7-git-send-email-walken@google.com> <5053AC2F.3070203@gmail.com> <CANN689Ff3W4z=+3J8aGO-2GrPHGJ=ote_f5q9jzRQRAP+b0T4Q@mail.gmail.com> <20120915000029.GA29426@google.com> <505433A0.3010702@suse.cz> <alpine.LSU.2.00.1209161130460.5591@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1209161130460.5591@eggly.anvils>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2012 09:07 PM, Hugh Dickins wrote:
>> What was the way that
>> Hugh used to reproduce the other issue?
> 
> I've lost track of which issue is "other".

The other was meant to be the BUG I hit.

> To reproduce Sasha's interval_tree.c warnings, all I had to do was switch
> on CONFIG_DEBUG_VM_RB (I regret not having done so before) and boot up.
> 
> I didn't look to see what was doing the mremap which caused the warning
> until now: surprisingly, it's microcode_ctl.  I've not made much effort
> to get the right set of sources and work out why that would be using
> mremap (a realloc inside a library?).
> 
> I failed to reproduce your BUG in huge_memory.c, but what I was trying
> was SuSE update via yast2, on several machines; but perhaps because
> they were all fairly close to up-to-date, I didn't hit a problem.
> (That was before I turned on DEBUG_VM_RB for Sasha's.)

The good news are that I cannot reproduce either with the patch applied.

thanks,
-- 
js
suse labs
