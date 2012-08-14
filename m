Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab2HNV4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 17:56:41 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59908 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab2HNV4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 17:56:38 -0400
Date: Tue, 14 Aug 2012 14:56:32 -0700
From: Tejun Heo <tj@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mingo@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCHSET] timer: clean up initializers and implement irqsafe
 timers
Message-ID: <20120814215632.GE25632@google.com>
References: <1344449428-24962-1-git-send-email-tj@kernel.org>
 <20120813233520.GG25632@google.com>
 <alpine.LFD.2.02.1208142055260.32033@ionos>
 <20120814192203.GY25632@google.com>
 <alpine.LFD.2.02.1208142243500.32033@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1208142243500.32033@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Thomas.

On Tue, Aug 14, 2012 at 11:03:33PM +0200, Thomas Gleixner wrote:
> Why should -next have different rules to mainline?

It's faster paced and trees revert.  The message specifically was a
ping for objection and I was waiting for further response and would
have waited until early next week (and written another "applied"
message which would be another chance to veto).  And even if that
isn't enough for whatever reason and you or anyone else object it
afterwards, it'll get reverted / reouted differently / whatever.

As for subsystem boundary, at least I cross them and let others cross
if the changes aren't significant and the proposed changes are likely
to be be used only in that tree for the devel window.  The timer
change seems borderline to me.  It isn't trivial but doesn't seem all
that invasive to me.

I don't think any critical protocol is breached here.  If you're upset
about the style of the ping, I apologize.  I'll try to be more
sensitive when pinging you.

Thanks.

-- 
tejun
