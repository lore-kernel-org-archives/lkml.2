Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031733Ab2CGAym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 19:54:42 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64015 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701Ab2CGAyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 19:54:41 -0500
MIME-Version: 1.0
In-Reply-To: <1331067743.11248.333.camel@twins>
References: <20120306204357.13169.90791.stgit@zurg> <1331067743.11248.333.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Mar 2012 16:54:20 -0800
X-Google-Sender-Auth: a5X2_XgJtjaI-5YrIywnFHwlTas
Message-ID: <CA+55aFxPiW=T8iNy=Fb_fuO2DYV9+sQL-mr8=Uc7cWymTyVt6A@mail.gmail.com>
Subject: Re: [PATCH bisected regression] sched: rebuild sched domains at suspend/resume
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 1:02 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> This changelog also completely fails to explain what the problem was and
> how this patch sorts it without re-introducing the problems 8f2f748b0656
> was supposed to fix.
>
> I'd rather revert the 'fix' and think about this more (its been broken
> pretty much forever anyway) than tinker on top like this.

Ok, guys, I don't care whether it's the revert or the addition of
rebuild_sched_domains(), but I'd like for somebody to make that
decision and test the end result.

I do agree that reverting is probably safer at this point, but can we
get agreement on this?

               Linus
