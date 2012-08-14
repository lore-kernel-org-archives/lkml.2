Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab2HNCIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 22:08:39 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:44143 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab2HNCIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 22:08:37 -0400
Message-ID: <5029B309.9020008@linux.vnet.ibm.com>
Date: Tue, 14 Aug 2012 10:08:09 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Dong Hao <haodong@linux.vnet.ibm.com>, avi@redhat.com, mtosatti@redhat.com,
        mingo@elte.hu, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 3/3] KVM: perf kvm events analysis tool
References: <1344568750-5147-1-git-send-email-haodong@linux.vnet.ibm.com> <1344568750-5147-4-git-send-email-haodong@linux.vnet.ibm.com> <20120810141424.GB31149@infradead.org>
In-Reply-To: <20120810141424.GB31149@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12081402-2674-0000-0000-00000596B143
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2012 10:14 PM, Arnaldo Carvalho de Melo wrote:
> Em Fri, Aug 10, 2012 at 11:19:10AM +0800, Dong Hao escreveu:
>> From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>>
>> Add 'perf kvm stat' support to analyze kvm vmexit/mmio/ioport smartly.
> 
> Some comments below about recent changes in my perf/core branch.

Arnaldo,

Thank you very much for your review! All of your comments are fine to us,
we will correct them in the next version.

