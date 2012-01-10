Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab2AJEq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 23:46:28 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:38840 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062Ab2AJEq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 23:46:26 -0500
Message-ID: <4F0BC298.7090608@linux.vnet.ibm.com>
Date: Tue, 10 Jan 2012 12:46:16 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/8] KVM: MMU: set the dirty bit for the upper shadow
 page
References: <4EEB19AF.5070501@linux.vnet.ibm.com> <4EEB1A00.8090707@linux.vnet.ibm.com> <20120109113005.GB5255@amt.cnet>
In-Reply-To: <20120109113005.GB5255@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12011004-2000-0000-0000-000005FC0F41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2012 07:30 PM, Marcelo Tosatti wrote:

> On Fri, Dec 16, 2011 at 06:14:24PM +0800, Xiao Guangrong wrote:
>> Upper page do not need to be tracked the status bit, it is safe to set the
>> dirty and let cpu to happily prefetch it
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/mmu.c |   13 +++++--------
>>  1 files changed, 5 insertions(+), 8 deletions(-)
> 
> Dirty bit is ignored in non-leaf pagetable entries.
> 

Sorry, i forgot it!

