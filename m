Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab1EIQf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 12:35:59 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:47208 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab1EIQf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 12:35:58 -0400
Date: Mon, 9 May 2011 22:05:40 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        kexec@lists.infradead.org, ying.huang@intel.com
Subject: Re: [Bug] Kdump does not work when panic triggered due to MCE
Message-ID: <20110509163540.GA1963@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20110506165412.GB2719@in.ibm.com>
 <20110506173825.GK11636@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110506173825.GK11636@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 07:38:25PM +0200, Andi Kleen wrote:
> > Has anybody tested this before? Or have found kdump working when fatal
> > MCEs have actually occurred?
> 
> Ying did some testing. mce-test has test cases for kdump.
> 

We'd be glad to hear about any successful testcases with recent kernels.
My manual testing was quite similar to what the LTP kdump testcase would
do i.e. configure kdump service, trigger crash through
/proc/sysrq-trigger and watchout for kdump....but as you could see in
the logs, that did not happen.

> My guess is you injected the error into some area used by the kexec
> code or boot up path of the kexec kernel.
> 
> -Andi

The logs did not suggest that the second kernel was booted into. The
"Rebooting in ... seconds" message appeared from the first kernel. I
tried the kdump testcase in atleast two dissimilar machines but with
the same results, so it is not clear if the kexec code was affected by
the MCE injection in both the cases.

Thanks,
K.Prasad

