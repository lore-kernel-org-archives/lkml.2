Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab2GIMsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 08:48:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466Ab2GIMse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 08:48:34 -0400
Message-ID: <4FFAD31D.7070703@redhat.com>
Date: Mon, 09 Jul 2012 15:48:29 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: X86: remove read buffer for mmio read
References: <4FFA9E16.10001@linux.vnet.ibm.com> <4FFABD59.2070108@redhat.com> <20120709112346.GA23898@redhat.com>
In-Reply-To: <20120709112346.GA23898@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2012 02:23 PM, Gleb Natapov wrote:
> 
>> kvm-unit-tests.git has a test for xchg to mmio.  Does it still work?
>> 
>> I agree this code has to go, but it needs to be replaced by something.
>> Maybe a .valid flag in struct operand.
>> 
> Valid will not enough for that.

If me make everything go through operands, why not?


-- 
error compiling committee.c: too many arguments to function


