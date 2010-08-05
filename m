Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab0HEAww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 20:52:52 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:52634 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab0HEAwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 20:52:51 -0400
Subject: Re: [PATCH] [RFC] notify userspace about time changes
From: john stultz <johnstul@us.ibm.com>
To: Chris Friesen <chris.friesen@genband.com>
Cc: Alexander Shishkin <virtuoso@slind.org>, gregkh@suse.de,
        lkml@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Kacur <jkacur@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <4C59B5E1.9040707@genband.com>
References: <1280926108-24668-1-git-send-email-virtuoso@slind.org>
	 <1280937526.28884.21.camel@work-vm>  <4C59B5E1.9040707@genband.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 17:52:26 -0700
Message-ID: <1280969546.2678.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 12:48 -0600, Chris Friesen wrote:
> On 08/04/2010 09:58 AM, john stultz wrote:
> 
> > Is there a actual use case that you need this for?  I don't really have
> > an issue with the code I just really want to make sure the feature would
> > be useful enough to justify the API and code maintenance going forward.
> 
> We actually added a time-change-notification mechanism internally a long
> time ago but never saw demand for it and so never bothered trying to
> push it upstream.  Ours is signal-based.
> 
> Among other things we use it to pass on time-change notifications to an
> emulator running a proprietary OS that really cares about having an
> accurate time-of-day but can't afford a syscall to retrieve it every time.

So the eventfd based method (and the filtering) proposed would work for
you? 

thanks
-john


