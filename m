Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab2JEQRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:17:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55816 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491Ab2JEQRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:17:46 -0400
Date: Fri, 5 Oct 2012 09:17:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Huacai Chen <chenhc@lemote.com>, Charles Wang <muming.wq@taobao.com>,
        Ingo Molnar <mingo@kernel.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Seems like "sched: Add missing call to calc_load_exit_idle()"
 should be reverted in 3.5 branch
Message-ID: <20121005161742.GA20855@kroah.com>
References: <CAAhV-H54CJdg+UekpucZ=kOgCY5r5vvYQ+v4VwAMTCv+mCedXA@mail.gmail.com>
 <20121004174626.GB14301@kroah.com>
 <1349375519.14388.16.camel@twins>
 <20121004222755.GC3609@kroah.com>
 <1349432466.14388.25.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349432466.14388.25.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 12:21:06PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-10-04 at 15:27 -0700, Greg Kroah-Hartman wrote:
> > I'm puzzled as well.  Any ideas if I should do anything here or not?
> 
> So I think the current v3.5.5 code is fine. I'm just not smart enough to
> figure out how 3.6 got fuzzed, this git thing is confusing as hell.

Thanks for letting me know, and digging through this, I'll leave things
as-is.

greg k-h
