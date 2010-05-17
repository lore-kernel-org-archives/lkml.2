Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab0EQJVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 05:21:53 -0400
Received: from mga06.intel.com ([134.134.136.21]:18020 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754608Ab0EQJVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 05:21:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,246,1272870000"; 
   d="scan'208";a="622226414"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH][v2 1/3] x86: Export FPU API for KVM use
Date: Mon, 17 May 2010 17:19:22 +0800
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: Marcelo Tosatti <mtosatti@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1274087308-26676-1-git-send-email-sheng@linux.intel.com> <1274087308-26676-2-git-send-email-sheng@linux.intel.com> <4BF10A06.5040902@redhat.com>
In-Reply-To: <4BF10A06.5040902@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005171719.23570.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 May 2010 17:19:02 Avi Kivity wrote:
> On 05/17/2010 12:08 PM, Sheng Yang wrote:
> > Also add some constants.
> > 
> > 
> > +++ b/arch/x86/kernel/process.c
> > @@ -28,6 +28,7 @@ unsigned long idle_nomwait;
> > 
> >   EXPORT_SYMBOL(idle_nomwait);
> >   
> >   struct kmem_cache *task_xstate_cachep;
> > 
> > +EXPORT_SYMBOL(task_xstate_cachep);
> > 
> >   int arch_dup_task_struct(struct task_struct *dst, struct task_struct
> >   *src) {
> 
> _GPL() unless good reason not to.

Oops... Just copied and pasted the above line...

--
regards
Yang, Sheng
