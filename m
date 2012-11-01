Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760848Ab2KAANf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 20:13:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786Ab2KAANd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 20:13:33 -0400
Date: Wed, 31 Oct 2012 22:05:40 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] emulator test: add "rep ins" mmio access test
Message-ID: <20121101000539.GB20153@amt.cnet>
References: <5081033C.4060503@linux.vnet.ibm.com>
 <5081039C.1040303@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5081039C.1040303@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 03:39:08PM +0800, Xiao Guangrong wrote:
> Add the test to trigger the bug that "rep ins" causes vcpu->mmio_fragments
> overflow overflow while move large data from ioport to MMIO
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  x86/emulator.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)

Applied, thanks.

