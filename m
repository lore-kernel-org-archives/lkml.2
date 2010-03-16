Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966091Ab0CPJeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 05:34:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966065Ab0CPJd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 05:33:59 -0400
Message-ID: <4B9F5078.10902@redhat.com>
Date: Tue, 16 Mar 2010 11:33:44 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
References: <1268717232.2813.36.camel@localhost>	 <4B9F19F7.6000309@redhat.com>  <1268725724.2813.48.camel@localhost> <1268731733.2813.54.camel@localhost>
In-Reply-To: <1268731733.2813.54.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 11:28 AM, Zhang, Yanmin wrote:
> Sorry. I found currently --pid isn't process but a thread (main thread).
>
> Ingo,
>
> Is it possible to support a new parameter or extend --inherit, so 'perf record' and
> 'perf top' could collect data on all threads of a process when the process is running?
>    

That seems like a worthwhile addition regardless of this thread.  
Profile all current threads and any new ones.  It probably makes sense 
to call this --pid and rename the existing --pid to --thread.

-- 
error compiling committee.c: too many arguments to function

