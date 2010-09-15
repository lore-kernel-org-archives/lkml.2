Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab0IOIuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 04:50:06 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:56218 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699Ab0IOIuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 04:50:04 -0400
Date: Wed, 15 Sep 2010 09:50:03 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        paulus <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, dhowells <dhowells@redhat.com>,
        Russell King <rmk@arm.linux.org.uk>, Kyle McMartin <kyle@mcmartin.ca>,
        davem <davem@davemloft.net>, Linux-Arch <linux-arch@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH -tip -v4] irq_work: generic hard-irq context callbacks
Message-ID: <20100915085003.GA20697@console-pimps.org>
References: <1284360648.3269.115.camel@yhuang-dev.sh.intel.com> <20100913123213.76b1b5fa@mschwide.boeblingen.de.ibm.com> <1284377790.2275.212.camel@laptop> <1284528590.2256.135.camel@yhuang-dev.sh.intel.com> <1284539320.3764.266.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284539320.3764.266.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 10:28:40AM +0200, Peter Zijlstra wrote:
> 
> I've got a patch to solve the Alpha issue, and I've got a patch for one
> of the SH issues as well, but I understand you need to pull in Paul
> Mundt's SH tree to make it fully build.

FWIW this is the commit that is missing in Linus' tree which fixes the
build issues,

http://git.kernel.org/?p=linux/kernel/git/lethal/sh-2.6.git;a=commit;h=b9afa3e015273a52718e0a7efe198a0df76be880

I'm guessing Paul will be sending a pull request to fix this breakage
before 2.6.36 is released.
