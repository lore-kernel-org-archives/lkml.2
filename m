Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab2JKKkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 06:40:37 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:49911 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab2JKKkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:40:33 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: habanero@linux.vnet.ibm.com,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>, KVM <kvm@vger.kernel.org>,
        Jiannan Ouyang <ouyang@cs.pitt.edu>, chegu vinod <chegu_vinod@hp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH RFC 1/2] kvm: Handle undercommitted guest case in PLE handler
In-Reply-To: <1349879095.5551.266.camel@oc6622382223.ibm.com>
References: <20120921120000.27611.71321.sendpatchset@codeblue> <505C654B.2050106@redhat.com> <505CA2EB.7050403@linux.vnet.ibm.com> <50607F1F.2040704@redhat.com> <20121003122209.GA9076@linux.vnet.ibm.com> <506C7057.6000102@redhat.com> <506D69AB.7020400@linux.vnet.ibm.com> <506D83EE.2020303@redhat.com> <1349356038.14388.3.camel@twins> <506DA48C.8050200@redhat.com>  <20121009185108.GA2549@linux.vnet.ibm.com> <1349879095.5551.266.camel@oc6622382223.ibm.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-redhat-linux-gnu)
Date: Thu, 11 Oct 2012 16:09:35 +0530
Message-ID: <877gqxfg2g.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12101110-3864-0000-0000-000005048F68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012 09:24:55 -0500, Andrew Theurer <habanero@linux.vnet.ibm.com> wrote:
> 
> Below is again 8 x 20-way VMs, but this time I tried out Nikunj's gang
> scheduling patches.  While I am not recommending gang scheduling, I
> think it's a good data point.  The performance is 3.88x the PLE result.
> 
> https://docs.google.com/open?id=0B6tfUNlZ-14wWXdscWcwNTVEY3M

That looks pretty good and serves the purpose. And the result says it all.

> Note that the task switching intervals of 4ms are quite obvious again,
> and this time all vCPUs from same VM run at the same time.  It
> represents the best possible outcome.
> 
> 
> Anyway, I thought the bitmaps might help better visualize what's going
> on.
> 
> -Andrew
> 

Regards
Nikunj

