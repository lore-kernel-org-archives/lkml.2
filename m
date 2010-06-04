Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab0FDRKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 13:10:30 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59320 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab0FDRK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 13:10:29 -0400
Message-ID: <4C09337E.3070504@linux.vnet.ibm.com>
Date: Fri, 04 Jun 2010 10:10:22 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: perf: tools/perf/design.txt is badly out of date
References: <4C083D2C.5070204@linux.vnet.ibm.com> <1275644908.27810.39476.camel@twins>
In-Reply-To: <1275644908.27810.39476.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe the file should at least move to the normal burial ground for docs, Documentation, rather than where it is today tools/perf.  Perhaps there it would be easier for people to find and correct.

On 6/4/2010 2:48 AM, Peter Zijlstra wrote:
> On Thu, 2010-06-03 at 16:39 -0700, Corey Ashford wrote:
>> I had a glance at tools/perf/design.txt the other day, and it
>> appears to be pretty far out of date.
>>
>> Is design.txt a document that you want to keep the current way for
>> historical reasons [and the up-to-date documentation placed somewhere
>> else], or one that should be maintained?
>>
>> I'm wondering if some/all of this documentation should move into
>> include/linux/perf_event.h
> 
> Its the ineffiteble fate of everything Documentation/ to be out-dated.
> But yeah, that file will be woefully inaccurate by now.
> 
> Yeah, I think making perf_event.h more explanatory would be good. But I
> don't think we want to go overboard there either, if comments get too
> large and unwieldy they tend to bitrot just as hard as Documentation/
> 
> 

-- 
Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR 
503-578-3507 
cjashfor@us.ibm.com
