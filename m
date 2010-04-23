Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab0DWKvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 06:51:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757038Ab0DWKvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 06:51:03 -0400
Message-ID: <4BD17B78.5080305@redhat.com>
Date: Fri, 23 Apr 2010 13:50:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Liu Yu-B13201 <B13201@freescale.com>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com, tim.c.chen@intel.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH V5 1/3] perf & kvm: Enhance perf to collect KVM guest
 os statistics from host side
References: <1271655161.2078.603.camel@ymzhang.sh.intel.com> <0A1FE637C2C7E148B9573BB60CC630E5905A23@zch01exm26.fsl.freescale.net>
In-Reply-To: <0A1FE637C2C7E148B9573BB60CC630E5905A23@zch01exm26.fsl.freescale.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2010 01:27 PM, Liu Yu-B13201 wrote:
>
> I met this error when built kernel. Anything wrong?
>
>    CC      init/main.o
> In file included from include/linux/ftrace_event.h:8,
>                   from include/trace/syscall.h:6,
>                   from include/linux/syscalls.h:75,
>                   from init/main.c:16:
> include/linux/perf_event.h: In function 'perf_register_guest_info_callbacks':
> include/linux/perf_event.h:1019: error: parameter name omitted
> include/linux/perf_event.h: In function 'perf_unregister_guest_info_callbacks':
> include/linux/perf_event.h:1021: error: parameter name omitted
> make[1]: *** [init/main.o] Error 1
> make: *** [init] Error 2
>    

I merged tip/perf/code which may fix this.  Find it in kvm.git next branch.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

