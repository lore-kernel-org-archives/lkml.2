Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220Ab0HEOUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:20:19 -0400
Received: from exprod7og118.obsmtp.com ([64.18.2.8]:57753 "EHLO
	exprod7og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476Ab0HEOUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:20:15 -0400
Message-ID: <4C5AC646.9010403@genband.com>
Date: Thu, 05 Aug 2010 08:10:14 -0600
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
References: <1280926108-24668-1-git-send-email-virtuoso@slind.org>	 <1280937526.28884.21.camel@work-vm>  <4C59B5E1.9040707@genband.com> <1280969546.2678.33.camel@localhost.localdomain>
In-Reply-To: <1280969546.2678.33.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Aug 2010 14:10:17.0039 (UTC) FILETIME=[EE2E5DF0:01CB34A7]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-17550.007
X-TM-AS-Result: No--21.957200-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2010 06:52 PM, john stultz wrote:
> On Wed, 2010-08-04 at 12:48 -0600, Chris Friesen wrote:
>> On 08/04/2010 09:58 AM, john stultz wrote:
>>
>>> Is there a actual use case that you need this for?  I don't really have
>>> an issue with the code I just really want to make sure the feature would
>>> be useful enough to justify the API and code maintenance going forward.
>>
>> We actually added a time-change-notification mechanism internally a long
>> time ago but never saw demand for it and so never bothered trying to
>> push it upstream.  Ours is signal-based.
>>
>> Among other things we use it to pass on time-change notifications to an
>> emulator running a proprietary OS that really cares about having an
>> accurate time-of-day but can't afford a syscall to retrieve it every time.
> 
> So the eventfd based method (and the filtering) proposed would work for
> you? 

The eventfd based method would work.  The filtering is unnecessary for
us and seems somewhat fragile as currently implemented.

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
