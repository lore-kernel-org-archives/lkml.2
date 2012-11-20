Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab2KTX0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 18:26:09 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:49155 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab2KTX0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 18:26:07 -0500
Message-ID: <50AC1188.5060703@linux.vnet.ibm.com>
Date: Wed, 21 Nov 2012 07:26:00 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/5] KVM: MMU: simplify set_spte
References: <5097AC70.1080904@linux.vnet.ibm.com> <5097ACD7.5030201@linux.vnet.ibm.com> <20121120222456.GB31427@amt.cnet>
In-Reply-To: <20121120222456.GB31427@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12112023-3864-0000-0000-000005A63B46
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000295; HX=3.00000198; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00193077; UDB=6.00043754; UTC=2012-11-20
 23:26:04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 06:24 AM, Marcelo Tosatti wrote:
> On Mon, Nov 05, 2012 at 08:11:03PM +0800, Xiao Guangrong wrote:
>> It is more cleaner if we can update pte_access fist then set spte according
>> to pte_access, also introduce gfn_need_write_protect to check whether the
>> gfn need to be write-protected
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> 
> Please separate patch in:
> - code movement with no logical modification.
> - logical modification (such as condition for mark_page_dirty).
> - move code to helper functions.

Okay, will split it.

