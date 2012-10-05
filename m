Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab2JERKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 13:10:19 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41570 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab2JERKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 13:10:16 -0400
Date: Fri, 5 Oct 2012 10:10:07 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Huacai Chen <chenhc@lemote.com>, Charles Wang <muming.wq@taobao.com>,
        Ingo Molnar <mingo@kernel.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Seems like "sched: Add missing call to calc_load_exit_idle()"
 should be reverted in 3.5 branch
Message-ID: <20121005171007.GC15867@elie.Belkin>
References: <CAAhV-H54CJdg+UekpucZ=kOgCY5r5vvYQ+v4VwAMTCv+mCedXA@mail.gmail.com>
 <20121004174626.GB14301@kroah.com>
 <1349375519.14388.16.camel@twins>
 <20121004222755.GC3609@kroah.com>
 <1349432466.14388.25.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349432466.14388.25.camel@twins>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2012-10-04 at 15:27 -0700, Greg Kroah-Hartman wrote:

>> I'm puzzled as well.  Any ideas if I should do anything here or not?
>
> So I think the current v3.5.5 code is fine.

Now I'm puzzled.  You wrote:

| However, since we don't restart the tick, we won't be sampling load muck
| and calling calc_load_exit_idle() from there is bound to confuse state.

Doesn't that mean 900404e5d201 "sched: Add missing call to
calc_load_exit_idle()" which is part of 3.5.5 was problematic?  Or
did I just miscount the number of "not"s?
