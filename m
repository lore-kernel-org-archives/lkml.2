Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab2GIN0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 09:26:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787Ab2GIN0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 09:26:13 -0400
Date: Mon, 9 Jul 2012 16:26:02 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: X86: remove read buffer for mmio read
Message-ID: <20120709132602.GA7298@redhat.com>
References: <4FFA9E16.10001@linux.vnet.ibm.com>
 <4FFABD59.2070108@redhat.com>
 <20120709112346.GA23898@redhat.com>
 <4FFAD341.3080508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FFAD341.3080508@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 03:49:05PM +0300, Avi Kivity wrote:
> On 07/09/2012 02:23 PM, Gleb Natapov wrote:
> > 
> >> kvm-unit-tests.git has a test for xchg to mmio.  Does it still work?
> >> 
> >> I agree this code has to go, but it needs to be replaced by something.
> >> Maybe a .valid flag in struct operand.
> >> 
> > Valid will not enough for that.
> 
> If we make everything go through operands, any reason why not?
> 
Ah I missed operand part. Thought about adding valid to x86.c mmio read
buffer. What about doing more complex things from MMIO, like task switch?

--
			Gleb.
