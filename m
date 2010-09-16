Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab0IPHDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 03:03:46 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:41649 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab0IPHDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 03:03:44 -0400
Date: Thu, 16 Sep 2010 16:03:41 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        paulus <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, dhowells <dhowells@redhat.com>,
        Russell King <rmk@arm.linux.org.uk>, Kyle McMartin <kyle@mcmartin.ca>,
        davem <davem@davemloft.net>, Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH -tip -v4] irq_work: generic hard-irq context callbacks
Message-ID: <20100916070340.GA12314@linux-sh.org>
References: <1284360648.3269.115.camel@yhuang-dev.sh.intel.com> <20100913123213.76b1b5fa@mschwide.boeblingen.de.ibm.com> <1284377790.2275.212.camel@laptop> <1284528590.2256.135.camel@yhuang-dev.sh.intel.com> <1284539320.3764.266.camel@twins> <20100915085003.GA20697@console-pimps.org> <1284620363.2754.430.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284620363.2754.430.camel@yhuang-dev>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 02:59:22PM +0800, Huang Ying wrote:
> On Wed, 2010-09-15 at 16:50 +0800, Matt Fleming wrote:
> > On Wed, Sep 15, 2010 at 10:28:40AM +0200, Peter Zijlstra wrote:
> > > 
> > > I've got a patch to solve the Alpha issue, and I've got a patch for one
> > > of the SH issues as well, but I understand you need to pull in Paul
> > > Mundt's SH tree to make it fully build.
> > 
> > FWIW this is the commit that is missing in Linus' tree which fixes the
> > build issues,
> > 
> > http://git.kernel.org/?p=linux/kernel/git/lethal/sh-2.6.git;a=commit;h=b9afa3e015273a52718e0a7efe198a0df76be880
> > 
> > I'm guessing Paul will be sending a pull request to fix this breakage
> > before 2.6.36 is released.
> 
> I have compile error even after merging full sh-2.6.git. Log is
> attached. I need a newer compiler?
> 
This is an issue with old versions of binutils, so simply using a more
recent version will be fine. If you don't feel like building one
yourself, you can just use the CodeSourcery one, which is generally the
most recent.
