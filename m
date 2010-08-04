Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab0HDPvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 11:51:14 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:43035 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab0HDPvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 11:51:11 -0400
Date: Wed, 4 Aug 2010 18:49:48 +0300
From: Alexander Shishkin <virtuoso@slind.org>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: lkml@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Kacur <jkacur@redhat.com>,
        linux-kernel@vger.kernel.org, Alexander Shishkin <virtuoso@slind.org>
Subject: Re: [PATCH] [RFC] notify userspace about time changes
Message-ID: <20100804154948.GC28519@shisha.kicks-ass.net>
Mail-Followup-To: Bastien ROUCARIES <roucaries.bastien@gmail.com>,
	lkml@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
	Thomas Gleixner <tglx@linutronix.de>,
	John Stultz <johnstul@us.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, John Kacur <jkacur@redhat.com>,
	linux-kernel@vger.kernel.org
References: <1280926108-24668-1-git-send-email-virtuoso@slind.org>
 <AANLkTimmD1wijmyiSY8xHLyr_fQF52LyUpn3fmT1W_3=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimmD1wijmyiSY8xHLyr_fQF52LyUpn3fmT1W_3=@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 02:54:12 +0200, Bastien ROUCARIES wrote:
> On Wed, Aug 4, 2010 at 2:48 PM, Alexander Shishkin <virtuoso@slind.org> wrote:
> > Certain userspace applications (like "clock" desktop applets or ntpd) might
> > want to be notified when some other application changes the system time. It
> > might also be important for an application to be able to distinguish between
> > its own and somebody else's time changes.
> 
> Why not implementing somtehing like http://lwn.net/Articles/323658/ a
> la plan 9 with a poll callback ?

Thanks for pointing this out, I'll investigate this approach.

> It will be plan9 compatible and so unix

I don't think that plan9 == unix statement is broadly correct, but I don't
know enough on the topic yet.

Regards,
--
Alex
