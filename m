Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab1C1XNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 19:13:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:54113 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab1C1XNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 19:13:23 -0400
Date: Tue, 29 Mar 2011 01:13:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Lutomirski <luto@mit.edu>
cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 3/6] x86-64: Put vsyscall_gtod_data at a fixed virtual
 address
In-Reply-To: <AANLkTik7d1LNhHHOf=twXbKfMbU3rRCqW6vMzWGk8s31@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1103290112270.2774@localhost6.localdomain6>
References: <cover.1301324270.git.luto@mit.edu> <4fef5b568241665e1d2bca64f73a437bafb574c4.1301324270.git.luto@mit.edu> <alpine.LFD.2.00.1103281947320.2774@localhost6.localdomain6> <AANLkTik7d1LNhHHOf=twXbKfMbU3rRCqW6vMzWGk8s31@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011, Andrew Lutomirski wrote:

> On Mon, Mar 28, 2011 at 1:49 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > NAK.
> 
> Consider this one withdrawn for now.  I'll redo this patch later on
> and resubmit it on its own.
> 
> Any comments on the rest of the series?  They're all independent
> changes, other than touching the same code.

Not at the moment. I'm swamped, sorry. Will have a look later.

Thanks,

	tglx
