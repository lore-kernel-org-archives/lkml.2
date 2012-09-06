Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab2IFGmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 02:42:42 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:49248 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab2IFGmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 02:42:40 -0400
Message-ID: <50484551.8080700@linux.vnet.ibm.com>
Date: Thu, 06 Sep 2012 12:10:17 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Tony Luck <tony.luck@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, ak@linux.intel.com, bp@amd64.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, ananth@in.ibm.com
Subject: Re: [PATCH] [mcelog] Start using the new sysfs tunables location
References: <20120905102156.9423.27806.stgit@localhost.localdomain> <20120905103237.9726.56131.stgit@localhost.localdomain> <20120905184708.GC16230@one.firstfloor.org> <CA+8MBbKx7x=MxgtV5URYuDWQcxz0nqohVB8gRpBHtDxqMBb9uw@mail.gmail.com>
In-Reply-To: <CA+8MBbKx7x=MxgtV5URYuDWQcxz0nqohVB8gRpBHtDxqMBb9uw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12090606-4790-0000-0000-00000479EF19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 12:39 AM, Tony Luck wrote:
> On Wed, Sep 5, 2012 at 11:47 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> On Wed, Sep 05, 2012 at 04:02:37PM +0530, Naveen N. Rao wrote:
>>> All the current mce tunables are now available under
>>> /sys/devices/system/machinecheck. Start using this new location, but fall back
>>> to the older per-cpu location so that we continue working with older kernels.
>>
>> Who did that change in the kernel?
>>
>> That breaks Linus rule that the kernel should not break userland.
>> Kernel needs to fix that.
>
> The change is still under discussion. Stage one is to add the new global
> pathnames in addition to keeping the old per-cpu ones. Also fix all utilities
> (just mcelog(8) as far as we know) to prefer the new paths.
>
> After some time[1] ... delete the old paths. This is allowable under Linus'
> modified edict that you can change ABI "if nobody complains". If we wait
> long enough that the new mcelog is widely deployed, then nobody should
> complain.
>
> -Tony
>
> [1] several years - not just a kernel release or two.
>

Tony,
Thanks for clarifying. I should have mentioned in the patch description 
that this is indeed subject to the original patch making it into the kernel.

On a related topic. I recently noticed that we don't have an entry for 
machinecheck in Documentation/ABI/. Should we add an entry in there? We 
could perhaps add the existing entries under obsolete/ and the new 
location under testing/?


- Naveen

