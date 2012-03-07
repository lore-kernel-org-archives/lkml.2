Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065Ab2CGPlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 10:41:32 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:49004 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562Ab2CGPla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 10:41:30 -0500
Message-ID: <4F578198.8060708@linux.vnet.ibm.com>
Date: Wed, 07 Mar 2012 21:11:12 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Sasha Levin <levinsasha928@gmail.com>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: the maxcpus= boot parameter broke somewhere along the line
References: <x49vcmhhj2f.fsf@segfault.boston.devel.redhat.com> <CA+1xoqe_xS95xKM2=X-Mq-_gc+DqzxF2D8YiuCf=0=7=mVKsyw@mail.gmail.com> <20120306164835.GA26094@elliptictech.com> <CA+1xoqfzCb5X8wwvR1Bz+D6K20n7v3ChUR0E4Jqw_BWam5C7TQ@mail.gmail.com> <x49mx7thabf.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49mx7thabf.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12030705-9264-0000-0000-00000103503A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2012 11:38 PM, Jeff Moyer wrote:

> Sasha Levin <levinsasha928@gmail.com> writes:
> 
>> I can't reproduce it locally with a 3.3-rc5 kernel.
> 
> First, thanks for looking into it.  I just did a git pull, up to -rc6,
> and the problem still persists on my machine.
>


I tried 3.3-rc4 as well as 3.3-rc6+ (last commit dac12d1). I did not
see the problem in either case.


> Again, let me know if there's anything else I can provide that would be
> helpful for debugging this.
> 


Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

