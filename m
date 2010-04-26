Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab0DZGLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 02:11:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:47802 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab0DZGL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 02:11:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,272,1270450800"; 
   d="scan'208";a="512398736"
Subject: Re: [PATCH V5 1/3] perf & kvm: Enhance perf to collect KVM guest
 os statistics from host side
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: Liu Yu-B13201 <B13201@freescale.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com, tim.c.chen@intel.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>
In-Reply-To: <4BD17B78.5080305@redhat.com>
References: <1271655161.2078.603.camel@ymzhang.sh.intel.com>
	 <0A1FE637C2C7E148B9573BB60CC630E5905A23@zch01exm26.fsl.freescale.net>
	 <4BD17B78.5080305@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 26 Apr 2010 14:11:44 +0800
Message-Id: <1272262304.2078.630.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-23 at 13:50 +0300, Avi Kivity wrote:
> On 04/22/2010 01:27 PM, Liu Yu-B13201 wrote:
> >
> > I met this error when built kernel. Anything wrong?
> >
> >    CC      init/main.o
> > In file included from include/linux/ftrace_event.h:8,
> >                   from include/trace/syscall.h:6,
> >                   from include/linux/syscalls.h:75,
> >                   from init/main.c:16:
> > include/linux/perf_event.h: In function 'perf_register_guest_info_callbacks':
> > include/linux/perf_event.h:1019: error: parameter name omitted
> > include/linux/perf_event.h: In function 'perf_unregister_guest_info_callbacks':
> > include/linux/perf_event.h:1021: error: parameter name omitted
> > make[1]: *** [init/main.o] Error 1
> > make: *** [init] Error 2
> >    
> 
> I merged tip/perf/code which may fix this.  Find it in kvm.git next branch.
I downloaded the latest kvm.git tree and compilation is ok, including both enabling
FTRACE and disabling FTRACE.

Yanmin


