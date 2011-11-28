Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab1K1Oj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:39:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab1K1Oj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:39:58 -0500
Message-ID: <4ED39D3A.6020808@redhat.com>
Date: Mon, 28 Nov 2011 16:39:54 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/5] KVM: x86: remove the dead code of KVM_EXIT_HYPERCALL
References: <4ED3811F.1070101@linux.vnet.ibm.com> <4ED38182.6070505@linux.vnet.ibm.com> <20111128125637.GS2557@redhat.com>
In-Reply-To: <20111128125637.GS2557@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2011 02:56 PM, Gleb Natapov wrote:
> On Mon, Nov 28, 2011 at 08:41:38PM +0800, Xiao Guangrong wrote:
> > KVM_EXIT_HYPERCALL is not used anymore, so remove the code
> > 
> Why not remove the define as well?
>
>

It's in kvm.h, best not to touch it in case someone has

  case KVM_EXIT_HYPERCALL:
       abort();

-- 
error compiling committee.c: too many arguments to function

