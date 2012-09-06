Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab2IFMgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 08:36:49 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:51211 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab2IFMgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 08:36:48 -0400
Message-ID: <50489853.3050906@linux.vnet.ibm.com>
Date: Thu, 06 Sep 2012 18:04:27 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Tony Luck <tony.luck@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        bp@amd64.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, ananth@in.ibm.com
Subject: Re: [PATCH] [mcelog] Start using the new sysfs tunables location
References: <20120905102156.9423.27806.stgit@localhost.localdomain> <20120905103237.9726.56131.stgit@localhost.localdomain> <20120905184708.GC16230@one.firstfloor.org> <CA+8MBbKx7x=MxgtV5URYuDWQcxz0nqohVB8gRpBHtDxqMBb9uw@mail.gmail.com> <20120906122850.GI17289@tassilo.jf.intel.com>
In-Reply-To: <20120906122850.GI17289@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12090612-7014-0000-0000-000001DA275A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 05:58 PM, Andi Kleen wrote:
>> The change is still under discussion. Stage one is to add the new global
>> pathnames in addition to keeping the old per-cpu ones. Also fix all utilities
>> (just mcelog(8) as far as we know) to prefer the new paths.
>
> But why do you even want to change it?  Does it fix anything?
> AFAIK the old setup -- while not being pretty -- works just fine.

The reason for this was explained in this thread:
http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg298302.html

Even if we decide not to remove these tunables from under their current 
per-cpu location, I still think it is much cleaner to have them 
available under /sys/devices/system/machinecheck.


- Naveen

