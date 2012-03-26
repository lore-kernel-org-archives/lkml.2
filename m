Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab2C0Onx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 10:43:53 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:46675 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab2C0Ong (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 10:43:36 -0400
Date: Mon, 26 Mar 2012 10:44:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: mingo@elte.hu, suresh.b.siddha@intel.com, jwboyer@redhat.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, yinghai@kernel.org
Subject: Re: [PATCH 2/3] x86/apic_ops: Replace apic_ops with x86_apic_ops.
Message-ID: <20120326144421.GA3593@phenom.dumpdata.com>
References: <1332294154.16101.97.camel@sbsiddha-desk.sc.intel.com>
 <1332385090-18056-1-git-send-email-konrad.wilk@oracle.com>
 <1332385090-18056-3-git-send-email-konrad.wilk@oracle.com>
 <20120323122444.GD13920@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120323122444.GD13920@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090201.4F71D20D.00E9,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 01:24:44PM +0100, Ingo Molnar wrote:
> 
> * Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> > . which makes the code fit within the rest of the x86_ops functions.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > [v1: Changed x86_apic -> x86_ioapic per Yinghai Lu <yinghai@kernel.org> suggestion]
> > Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > ---
> >  arch/x86/include/asm/io_apic.h  |   40 +++++++++++++++++++++--------
> >  arch/x86/include/asm/x86_init.h |    8 ++++++
> >  arch/x86/kernel/apic/io_apic.c  |   54 ++++----------------------------------
> >  arch/x86/kernel/setup.c         |    2 +-
> >  arch/x86/kernel/x86_init.c      |    8 ++++++
> >  5 files changed, 52 insertions(+), 60 deletions(-)
> 
> Ok, I guess we can do this.

Ingo,

I am not sure how your prefer these patches, but I think you like git pull, so please
git pull the following branch:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-ingo-3.4

which is based of your "x86-urgent-for-linus" branch and has the following patches:

Jeremy Fitzhardinge (1):
      x86: add io_apic_ops to allow interception

Konrad Rzeszutek Wilk (2):
      x86/apic_ops: Replace apic_ops with x86_apic_ops.
      xen/x86: Implement x86_apic_ops


 arch/x86/include/asm/io_apic.h  |   31 +++++++++++++++++++++++++++++--
 arch/x86/include/asm/x86_init.h |    8 ++++++++
 arch/x86/kernel/apic/io_apic.c  |   10 ++++++----
 arch/x86/kernel/setup.c         |    2 +-
 arch/x86/kernel/x86_init.c      |    8 ++++++++
 arch/x86/xen/Makefile           |    2 +-
 arch/x86/xen/apic.c             |   17 +++++++++++++++++
 arch/x86/xen/enlighten.c        |    2 ++
 arch/x86/xen/xen-ops.h          |    4 ++++
 9 files changed, 76 insertions(+), 8 deletions(-)

Please pull!
