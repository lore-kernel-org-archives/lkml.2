Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab2GWCbK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 22:31:10 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:52597 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab2GWCbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 22:31:07 -0400
Message-ID: <500CB763.9020802@linux.vnet.ibm.com>
Date: Mon, 23 Jul 2012 10:30:59 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, mingo@redhat.com, paul@paulmenage.org
Subject: Re: [PATCH 0/5] cpusets: dynamical scheduler domain flags
References: <50052A78.6000407@linux.vnet.ibm.com> <1342802550.2583.12.camel@twins>
In-Reply-To: <1342802550.2583.12.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12072302-8878-0000-0000-00000357728A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2012 12:42 AM, Peter Zijlstra wrote:
> On Tue, 2012-07-17 at 17:03 +0800, Michael Wang wrote:
>> This patch set provide a way for user to dynamically configure the scheduler
>> domain flags, which usually to be static. 
> 
> NAK.. you don't get to expose all this nonsense in a 'stable' ABI.
> 
> You shouldn't need to prod at them to begin with.

So is that means expose those domain flags to user is a bad idea at all?

Is this caused by that people don't need such feature or this feature
has do harm to kernel's stability?(it could be not...)

Regards,
Michael Wang

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


