Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab1JNSSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 14:18:24 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:52923 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab1JNSSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 14:18:23 -0400
Message-ID: <4E987CE6.10501@linux.vnet.ibm.com>
Date: Fri, 14 Oct 2011 23:48:14 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, rdunlap@xenotime.net,
        len.brown@intel.com, pavel@ucw.cz, a.p.zijlstra@chello.nl,
        linux-pm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Documentation/power: Update docs about suspend and
 CPU hotplug
References: <Pine.LNX.4.44L0.1110141140080.2036-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1110141140080.2036-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2011 09:14 PM, Alan Stern wrote:
> On Fri, 14 Oct 2011, Srivatsa S. Bhat wrote:
> 
>> Update the documentation about the interaction between the suspend (S3) call
>> path and the CPU hotplug infrastructure.
>> This patch focusses only on the activities of the freezer, cpu hotplug and
>> the notifications involved. It outlines how regular CPU hotplug differs from
>> the way it is invoked during suspend and also tries to explain the locking
>> involved.
>>
>> v2: Clarified the question, to emphasize that the document explains only
>>     the difference (and similarity) in the two code paths but not what happens
>>     when race conditions occur between them.
> 
> Drawing the two diagrams in parallel, the way this does, carries a very
> strong implication that the events being described happen in parallel.  
> It really would be much better to have two separate diagrams and point
> out the common portions.
> 

I felt that drawing this way side-by-side would make it easier to see where they
differ and where they call the same code. But if this is really causing everyone
to believe that it represents events happening in parallel, then I will think
of separating the two diagrams and still somehow effectively explain what I set
out to explain in this document. Thank you for pointing it out.

> Also, the document should discuss the issues involved in CPU hotplug.  
> In particular, what happens if the CPUs are not all the same, or if the 
> requiring differing microcodes.  And whether or not the microcode needs 
> to get reloaded (presumably only after hibernation, not after suspend).
> And what happens when a CPU is hot-unplugged and replaced with a 
> differeing CPU which is then hot-plugged.
> 

Ok, I'll add another section that deals with the whole CPU hotplug and microcode
story. I'll include it in the next version. Thank you.

-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
