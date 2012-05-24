Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab2EXF2D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 01:28:03 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35995 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab2EXF2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 01:28:01 -0400
Date: Thu, 24 May 2012 07:27:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/urgent fixes for v3.5
Message-ID: <20120524052755.GA23545@gmail.com>
References: <20120523113432.GA12142@gmail.com>
 <CA+55aFzCDKK56CRXWXrPPtok84KJY4BbORcT3GfEH8xmOfgP6g@mail.gmail.com>
 <4FBD1AC8.7020602@zytor.com>
 <20120523174844.GA3373@gmail.com>
 <CA+55aFwpja0NxBser2EXjoMRTf0xobcCURqGtqyRXi4daPW0gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwpja0NxBser2EXjoMRTf0xobcCURqGtqyRXi4daPW0gg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, May 23, 2012 at 10:48 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Also, we can rebase the whole branch and get rid of this one 
> > and of the merge commit it has.
> 
> I took it, but it was really unnecessary.

Agreed.

> There were printk() patches in the queue and being discussed 
> that needed this, but I wouldn't have pulled the end result if 
> they hadn't been fixed.

Yeah.

Thanks,

	Ingo
