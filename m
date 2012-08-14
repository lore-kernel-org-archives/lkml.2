Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab2HNXwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 19:52:47 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40907 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab2HNXwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 19:52:44 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1208150134070.32033@ionos>
References: <1344449428-24962-1-git-send-email-tj@kernel.org>
	<alpine.LFD.2.02.1208131720070.32033@ionos>
	<20120814191549.GX25632@google.com>
	<alpine.LFD.2.02.1208142118060.32033@ionos>
	<20120814214009.GD25632@google.com>
	<alpine.LFD.2.02.1208150045360.32033@ionos>
	<20120814232738.GG25632@google.com>
	<alpine.LFD.2.02.1208150134070.32033@ionos>
Date: Tue, 14 Aug 2012 16:52:42 -0700
X-Google-Sender-Auth: 51tQsGiVrj7x-p94F6a068pt-sU
Message-ID: <CAOS58YMOie06+Q0xkzyOwvGd-oeVHLFvrewU7UP_4ES2r4hK+g@mail.gmail.com>
Subject: Re: [PATCHSET] timer: clean up initializers and implement irqsafe timers
From: Tejun Heo <tj@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mingo@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 14, 2012 at 4:46 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Do you really expect that I follow all of kernel dev posts within a
> day of returning from a two weeks vacation?

The head message says on what it's based on and the git branch. I
can't read your mind or know your current state. You could have asked
using a proper sentence.

We can continue this, but I don't think this is leading any place
productive. I'm replying to your other reply about the suggestion
about implementing workqueue's own timerlist. Let's just talk about
that. Please.

Thanks.

-- 
tejun
