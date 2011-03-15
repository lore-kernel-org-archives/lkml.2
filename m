Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593Ab1COUdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:33:07 -0400
Received: from relay3.sgi.com ([192.48.152.1]:49938 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758488Ab1COUdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:33:05 -0400
Date: Tue, 15 Mar 2011 15:32:59 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Milton Miller <miltonm@bga.com>, Peter Zijlstra <peterz@infradead.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Anton Blanchard <anton@samba.org>,
        "xiaoguangrong@cn.fujitsu.com" <xiaoguangrong@cn.fujitsu.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "npiggin@gmail.com" <npiggin@gmail.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "efault@gmx.de" <efault@gmx.de>, Jan Beulich <JBeulich@novell.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4 v3] smp_call_function_many issues from review
Message-ID: <20110315203259.GO13658@sgi.com>
References: <smp-call-function-list-race-fix@mdm.bga.com>
 <ipi-list-reply@mdm.bga.com>
 <smp-cfm-list-comment@mdm.bga.com>
 <smp-call-function-list-race-fix-v2@mdm.bga.com>
 <20110201220026.GD2142@linux.vnet.ibm.com>
 <ipi-paul-reply@mdm.bga.com>
 <20110202041740.GB2129@linux.vnet.ibm.com>
 <20110206235136.GA23658@linux.vnet.ibm.com>
 <smp-call-function-intro-v3@mdm.bga.com>
 <987664A83D2D224EAE907B061CE93D53019DC07EB3@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D53019DC07EB3@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 01:22:31PM -0700, Luck, Tony wrote:
> > Dimitri or Tony, let me know if you would like a revert patch for
> > 75c1c91c to be added after patch 3.
> 
> It appears that we won't need this anymore, so sure - revert it.
>
Reverting it seems OK to me. 
