Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab0L2ThM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 14:37:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58513 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab0L2ThK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 14:37:10 -0500
Message-ID: <4D1B8DC8.6000104@zytor.com>
Date: Wed, 29 Dec 2010 11:36:40 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, tglx@linutronix.de, x86@kernel.org,
        eric.dumazet@gmail.com, yinghai@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, Pekka Enberg <penberg@kernel.org>,
        shaohui.zheng@intel.com
Subject: Re: [PATCH 13/16] x86: Unify cpu/apicid <-> NUMA node mapping between
 32 and 64bit
References: <1293536929-31683-1-git-send-email-tj@kernel.org> <1293536929-31683-14-git-send-email-tj@kernel.org> <alpine.DEB.2.00.1012281231070.8883@chino.kir.corp.google.com> <20101229105253.GK488@htj.dyndns.org>
In-Reply-To: <20101229105253.GK488@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2010 02:52 AM, Tejun Heo wrote:
> On Tue, Dec 28, 2010 at 12:35:45PM -0800, David Rientjes wrote:
>> This is going to conflict with a387e95a ("") in x86/numa, so you'll need 
>> the following hunk for acpi_fake_nodes().  I'm not sure why this patchset 
>> is being based on x86/apic-cleanup rather than x86/numa?
> 
> Because several patches from the patchset have already been committed
> into x86/apic-cleanup.  Thomas, Peter, if this needs to be rebased
> somewhere, let me know.
> 

x86/numa is already a dependent branch (on x86/amd-nb), so I'm fine
merging x86/apic-cleanup into that branch and then if you could rebase
it on top of the new x86/numa then I'll push it out tomorrow.

OK?

	-hpa
