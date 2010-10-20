Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab0JTLk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 07:40:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159Ab0JTLk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 07:40:26 -0400
Date: Wed, 20 Oct 2010 13:39:29 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "avi@redhat.com" <avi@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "riel@redhat.com" <riel@redhat.com>,
        "cl@linux-foundation.org" <cl@linux-foundation.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Re: [PATCH v7 02/12] Halt vcpu if page it tries to access is
 swapped out.
Message-ID: <20101020113929.GS10207@redhat.com>
References: <1287048176-2563-1-git-send-email-gleb@redhat.com>
 <1287048176-2563-3-git-send-email-gleb@redhat.com>
 <4CBED271.9000103@siemens.com>
 <20101020113300.GR10207@redhat.com>
 <4CBED41F.6030109@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBED41F.6030109@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 01:35:59PM +0200, Jan Kiszka wrote:
> Am 20.10.2010 13:33, Gleb Natapov wrote:
> > On Wed, Oct 20, 2010 at 01:28:49PM +0200, Jan Kiszka wrote:
> >>
> >> Based on early kvm-kmod experiments, it looks like this (and maybe more)
> >> breaks the build in arch/x86/kvm/x86.c if CONFIG_KVM_ASYNC_PF is
> >> disabled. Please have a look.
> >>
> > CONFIG_KVM_ASYNC_PF is always enabled on x86.
> 
> Ah, so this is more like CONFIG_HAVE_KVM_ASYNC_PF?
> 
Yes. Your name is probably better.

--
			Gleb.
