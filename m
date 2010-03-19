Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab0CSTFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 15:05:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:34468 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab0CSTFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 15:05:51 -0400
Message-ID: <4BA3CAB8.7000702@kernel.org>
Date: Fri, 19 Mar 2010 12:04:24 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Infinite loop on boot in free_early_partial due to start==end
 on tip/master
References: <1267801390.11737.38014.camel@zakaz.uk.xensource.com> <20100319182807.GA14985@phenom.dumpdata.com>
In-Reply-To: <20100319182807.GA14985@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2010 11:28 AM, Konrad Rzeszutek Wilk wrote:
>> Subject: x86: do not free zero sized per cpu areas
>>
>> This avoids an infinite loop in free_early_partial().
> 
> The patch fixed PV guests booting on Xen. I've added my
> Tested-by .. Please merge it in the release.
> 
> Thanks!
>>
>> Add a warning to free_early_partial to catch future problems.
>>
>> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> 
> Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

please check update version...

please check if this patch help...

http://patchwork.kernel.org/patch/83832/


YH
