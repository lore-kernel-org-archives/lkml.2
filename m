Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab0HDStc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:49:32 -0400
Received: from exprod7og111.obsmtp.com ([64.18.2.175]:54339 "EHLO
	exprod7og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab0HDStb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 14:49:31 -0400
Message-ID: <4C59B5E1.9040707@genband.com>
Date: Wed, 04 Aug 2010 12:48:01 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Alexander Shishkin <virtuoso@slind.org>, gregkh@suse.de,
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
Subject: Re: [PATCH] [RFC] notify userspace about time changes
References: <1280926108-24668-1-git-send-email-virtuoso@slind.org> <1280937526.28884.21.camel@work-vm>
In-Reply-To: <1280937526.28884.21.camel@work-vm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Aug 2010 18:48:04.0668 (UTC) FILETIME=[9272F7C0:01CB3405]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-17550.001
X-TM-AS-Result: No--14.454900-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2010 09:58 AM, john stultz wrote:

> Is there a actual use case that you need this for?  I don't really have
> an issue with the code I just really want to make sure the feature would
> be useful enough to justify the API and code maintenance going forward.

We actually added a time-change-notification mechanism internally a long
time ago but never saw demand for it and so never bothered trying to
push it upstream.  Ours is signal-based.

Among other things we use it to pass on time-change notifications to an
emulator running a proprietary OS that really cares about having an
accurate time-of-day but can't afford a syscall to retrieve it every time.

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
