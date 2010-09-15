Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab0IOPm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 11:42:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:57231 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab0IOPm0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 11:42:26 -0400
Subject: Re: [PATCH -tip -v4] irq_work: generic hard-irq context callbacks
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        paulus <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dhowells <dhowells@redhat.com>, Russell King <rmk@arm.linux.org.uk>,
        Kyle McMartin <kyle@mcmartin.ca>, davem <davem@davemloft.net>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>
In-Reply-To: <37141.91.60.150.116.1284563403.squirrel@www.firstfloor.org>
References: <37141.91.60.150.116.1284563403.squirrel@www.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 15 Sep 2010 17:41:57 +0200
Message-ID: <1284565317.3764.848.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-15 at 17:10 +0200, Andi Kleen wrote:
> > On Wed, 2010-09-15 at 13:29 +0800, Huang Ying wrote:
> >
> >> I uses the cross build tool from:
> >>
> >> http://www.kernel.org/pub/tools/crosstool/
> >
> > I'm not familiar with those, I build my own gcc-4.5.1 toolchains for all
> > targets that would actually build a gcc toolchains, for those that don't
> > I simply don't care about.
> 
> I don't think it's a reasonable requirement to have every contributor
> compile on all architectures. If that was a general requirement
> soon nobody would send patches anymore.
> 
> Cross arch breakages happen rarely and can be usually repaired after
> the fact.

I think its reasonable to at least try and compile bits if you
explicitly touch these architectures like the patch under consideration
does.


