Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030834Ab2CVDCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 23:02:41 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:24255 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030731Ab2CVDCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 23:02:38 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: mingo@elte.hu, suresh.b.siddha@intel.com, jwboyer@redhat.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, yinghai@kernel.org
Subject: Re: 3.2.1 Unable to reset IRR messages on boot. [BZ#804347]
Date: Wed, 21 Mar 2012 22:58:07 -0400
Message-Id: <1332385090-18056-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1332294154.16101.97.camel@sbsiddha-desk.sc.intel.com>
References: <1332294154.16101.97.camel@sbsiddha-desk.sc.intel.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F6A9647.007A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Ingo, please take a look - and if you are OK with them please put in them
> > the v3.4 queue - if you are not comfortable, then the above patch will have to
> > suffice as a work-around for the regression.
> > 
> >  arch/x86/include/asm/io_apic.h  |   31 +++++++++++++++++++++++++++++--
> >  arch/x86/include/asm/x86_init.h |    8 ++++++++
> >  arch/x86/kernel/apic/io_apic.c  |   10 ++++++----
> >  arch/x86/kernel/setup.c         |    2 +-
> >  arch/x86/kernel/x86_init.c      |    8 ++++++++
> >  arch/x86/xen/Makefile           |    2 +-
> >  arch/x86/xen/apic.c             |   17 +++++++++++++++++
> >  arch/x86/xen/enlighten.c        |    2 ++
> >  arch/x86/xen/xen-ops.h          |    4 ++++
> >  9 files changed, 76 insertions(+), 8 deletions(-)
> > Jeremy Fitzhardinge (1):
> >       x86: add io_apic_ops to allow interception
> > 
> > Konrad Rzeszutek Wilk (2):
> >       x86/apic_ops: Replace apic_ops with x86_apic_ops.
> >       xen/x86: Implement x86_apic_ops
> > 
> 
> Ingo, Konrad was mentioning you didn't like this pieces before.
> 
> But for what Xen is trying to do, either we have to pursue this or
> untangle the gsi and ioapic dependency.
> 
> I am ok with this path for now.
> 
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

Redid them per feedback. Please consider them for 3.4. Thanks!

