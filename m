Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab1CRIsH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 04:48:07 -0400
Received: from www.tglx.de ([62.245.132.106]:52299 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab1CRIr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 04:47:59 -0400
Date: Fri, 18 Mar 2011 09:44:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mgalbraith@suse.de
Subject: Re: [000/474] 2.6.33.8-longterm review
In-Reply-To: <20110317213822.GA27980@kroah.com>
Message-ID: <alpine.LFD.2.00.1103180942531.2787@localhost6.localdomain6>
References: <20110317213822.GA27980@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011, Greg KH wrote:

> Yeah, I know what you are thinking, "What, 2.6.33, are you crazy?"

Aren't we all crazy ?
 
> I'd prefer it if you didn't answer that question...

Too late. You should have put this before the question.

> So, if you are using .33, please give this patch a test and let me know
> if I've messed up anything (hint, I think I did, it's up to you to
> figure it out, consider it a test to see if anyone actually cares about
> this kernel version.)

We'll pull it into rt and figure out what breaks.
 
Thanks for the effort,

	tglx
