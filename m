Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab0CWEvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 00:51:37 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:53421 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab0CWEvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 00:51:36 -0400
Message-ID: <4BA84804.3080105@oracle.com>
Date: Mon, 22 Mar 2010 21:48:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 4/10] User Space Breakpoint Assistance Layer
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>	<20100320142541.11427.98291.sendpatchset@localhost6.localdomain6> <20100322214009.bb90d6e2.akpm@linux-foundation.org>
In-Reply-To: <20100322214009.bb90d6e2.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BA8485F.00E1:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/10 18:40, Andrew Morton wrote:
> On Sat, 20 Mar 2010 19:55:41 +0530 Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:
> 
>>
>> ...
>>
>> +/**
>> + * user_bkpt_validate_insn_addr - Validate if the instruction is an
>> + * executable vma.
> 
> It used to be the case that the above linebreak is "wrong".  (Nobody
> ever tests their kerneldoc output!) I have a vague feeling that this
> might have been fixed lately.  Randy?

Yes, that's OK now.  Not a problem.

-- 
~Randy
