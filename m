Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab0CQAmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 20:42:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab0CQAme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 20:42:34 -0400
Date: Tue, 16 Mar 2010 20:41:36 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Anthony Liguori <aliguori@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from host side
Message-ID: <20100317004136.GC17472@redhat.com>
References: <20100316130840.GA24808@elte.hu> <4B9F84C0.70706@redhat.com> <20100316133114.GB575@elte.hu> <y0mbpeo1f1y.fsf@fche.csb> <20100316155221.GA19699@elte.hu> <4B9FC11A.1070507@linux.vnet.ibm.com> <20100316175243.GC23859@elte.hu> <4B9FC8B2.6070404@linux.vnet.ibm.com> <20100316182809.GA26602@elte.hu> <4BA00E6A.7080903@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA00E6A.7080903@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Tue, Mar 16, 2010 at 06:04:10PM -0500, Anthony Liguori wrote:
> [...]
> The only way to really address this is to change the interaction.  
> Instead of running perf externally to qemu, we should support a perf 
> command in the qemu monitor that can then tie directly to the perf 
> tooling.  That gives us the best possible user experience.

To what extent could this be solved with less crossing of
isolation/abstraction layers, if the perfctr facilities were properly
virtualized?  That way guests could run perf goo internally.
Optionally virt tools on the host side could aggregate data from
cooperating self-monitoring guests.

- FChE
