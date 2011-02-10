Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab1BJTep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 14:34:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246Ab1BJTeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 14:34:44 -0500
MIME-Version: 1.0
In-Reply-To: <20110210124416.GE26094@elte.hu>
References: <201102091608.59448.rusty@rustcorp.com.au> <20110210124416.GE26094@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 10 Feb 2011 11:29:02 -0800
Message-ID: <AANLkTi=zr5bZTankxU3oysM_bP=ty1Bze7K8BQ75yMBL@mail.gmail.com>
Subject: Re: [PULL] cpumask offstack finalization
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        anton@samba.org, Mike Travis <travis@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 4:44 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Hm, could we get rid of the obsolete percpu APIs once and for all? The fact that
> they are still around cause the leakage into new code to begin with.

Yes please.

And please don't expect it to be merged until the 39 merge window
unless this also fixes some serious bugs (I assume - without having
looked at the patch - that none of these are actually on-stack and
relevant for any thousand+ cpu machines?)

                      Linus
