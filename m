Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab1EWUes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:34:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753052Ab1EWUep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:34:45 -0400
MIME-Version: 1.0
In-Reply-To: <20110523192056.GC23629@elte.hu>
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com> <20110523192056.GC23629@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 May 2011 13:33:48 -0700
Message-ID: <BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com>
Subject: Re: (Short?) merge window reminder
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, DRI <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 12:20 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> I really hope there's also a voice that tells you to wait until .42 before
> cutting 3.0.0! :-)

So I'm toying with 3.0 (and in that case, it really would be "3.0",
not "3.0.0" - the stable team would get the third digit rather than
the fourth one.

But no, it wouldn't be for 42. Despite THHGTTG, I think "40" is a
fairly nice round number.

There's also the timing issue - since we no longer do version numbers
based on features, but based on time, just saying "we're about to
start the third decade" works as well as any other excuse.

But we'll see.

                           Linus
