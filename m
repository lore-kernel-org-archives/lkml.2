Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab2HCIOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 04:14:11 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:38886 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab2HCIOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 04:14:06 -0400
Message-ID: <501B8842.9040109@linux.vnet.ibm.com>
Date: Fri, 03 Aug 2012 16:13:54 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/9] KVM: define kvm_bad_pfn statically
References: <5014F053.8020305@linux.vnet.ibm.com> <5014F0E1.4010909@linux.vnet.ibm.com> <20120802131527.GE25344@amt.cnet> <20120803000125.GB12559@bloggs.ozlabs.ibm.com>
In-Reply-To: <20120803000125.GB12559@bloggs.ozlabs.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12080308-9574-0000-0000-000003D34037
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcelo, Paul,

Thanks for your review!

On 08/03/2012 08:01 AM, Paul Mackerras wrote:
> On Thu, Aug 02, 2012 at 10:15:27AM -0300, Marcelo Tosatti wrote:
> 
>> Remind me what is the guarantee that -Exxx does not clash with
>> a valid pfn number?
> 
> A pfn number is an address >> PAGE_SHIFT, so it will have the top 12
> (at least) bits clear, whereas -Exxx will have the top bit set.
> 

Yes.

As this way is hard to understand and it will break huge memory support
on PAE 32bit cpu, i have used a new way in the v2:

http://marc.info/?l=linux-kernel&m=134398012027025&w=2

Please review the new version.



