Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab2K1F1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 00:27:50 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:37613 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2K1F1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 00:27:48 -0500
Message-ID: <50B5A0CA.8060807@linux.vnet.ibm.com>
Date: Wed, 28 Nov 2012 13:27:38 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: MMU: lazily drop large spte
References: <20121112231032.GB5798@amt.cnet> <50A20428.1030004@linux.vnet.ibm.com> <20121114143747.GA7054@amt.cnet> <50A4267B.1030902@linux.vnet.ibm.com> <20121116030222.GA21822@amt.cnet> <50A5B560.2070604@linux.vnet.ibm.com> <20121116035655.GA27414@amt.cnet> <50A5C518.7030002@linux.vnet.ibm.com> <20121116095752.GA21401@amt.cnet> <50A799DA.7050900@linux.vnet.ibm.com> <20121118030040.GA5334@amt.cnet>
In-Reply-To: <20121118030040.GA5334@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12112805-7014-0000-0000-000002449A8C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2012 11:00 AM, Marcelo Tosatti wrote:
map gfn 4?  See corrected step 7 above.
>>
>> Ah, this is a real bug, and unfortunately, it exists in current
>> code. I will make a separate patchset to fix it. Thank you, Marcelo!
> 
> Is it? Hum..
> 
> Anyway, it would be great if you can write a testcase (should be similar
> in size to rmap_chain).

Marcelo, is this patch acceptable?

