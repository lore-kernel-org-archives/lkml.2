Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab1AUOAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 09:00:12 -0500
Received: from www.tglx.de ([62.245.132.106]:48505 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab1AUOAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 09:00:11 -0500
Date: Fri, 21 Jan 2011 14:59:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Torben Hohn <torbenh@gmx.de>
cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com, hch@infradead.org,
        tglx@tglx.de
Subject: Re: [PATCH] RFC: change do_timer() to take xtime lock, and provide
 do_timer_locked()
In-Reply-To: <1295617090-24896-1-git-send-email-torbenh@gmx.de>
Message-ID: <alpine.LFD.2.00.1101211458400.2971@localhost6.localdomain6>
References: <AANLkTikS0WAUngUXVx3uCynXt07-1L+=aR5A09XOMtK9@mail.gmail.com> <1295617090-24896-1-git-send-email-torbenh@gmx.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011, Torben Hohn wrote:

> in an effort to reduce occurrences of xtime_lock in the codebase,
> this commit makes do_timer take the xtime lock.
> 
> there are quite some occurences where arch code seems to protect
> other datastructures with this lock too.
> we provide do_timer_locked() for these occurences.
> 
> however, for this change to make sense, we should try to get rid
> of most calls to do_timer_locked()
> gonna try to address that in other arch specific commits.

Please see my other mail. We really don't want all that churn in one
large commit.

Thanks,

	tglx
