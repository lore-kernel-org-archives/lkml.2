Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab2HWPPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:15:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:55989 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab2HWPPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:15:44 -0400
Date: Thu, 23 Aug 2012 17:15:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Attilio Rao <attilio.rao@citrix.com>
cc: "x86@kernel.org" <x86@kernel.org>, Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH v2 0/5] X86/XEN: Merge x86_init.paging.pagetable_setup_start
 and x86_init.paging.pagetable_setup_done setup functions and document its
 semantic
In-Reply-To: <5035F7BD.6090205@citrix.com>
Message-ID: <alpine.LFD.2.02.1208231714450.2856@ionos>
References: <1345580561-8506-1-git-send-email-attilio.rao@citrix.com> <alpine.LFD.2.02.1208212315330.2856@ionos> <20120822135753.GA30964@phenom.dumpdata.com> <alpine.LFD.2.02.1208221618380.2856@ionos> <5034F0FD.8040902@citrix.com>
 <5035F7BD.6090205@citrix.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2012, Attilio Rao wrote:
> On 22/08/12 15:47, Attilio Rao wrote:
> > but I would like to repost the patch serie skipping the referral to
> > PVOPS in the commit logs, I will do so right now, so please wait for
> > another patch serie.
> >    
> 
> For your convenience:
> http://lkml.org/lkml/2012/8/22/450

Not very convenient. I really prefer e-mail :)
