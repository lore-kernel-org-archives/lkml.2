Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab2APJiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 04:38:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab2APJiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 04:38:08 -0500
Message-ID: <4F13EFFB.90706@redhat.com>
Date: Mon, 16 Jan 2012 11:38:03 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: improve trace events of vmexit/mmio/ioport
References: <4F13EE3D.2070602@linux.vnet.ibm.com> <4F13EE9B.9020901@linux.vnet.ibm.com>
In-Reply-To: <4F13EE9B.9020901@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2012 11:32 AM, Xiao Guangrong wrote:
> - trace vcpu_id for these events

We can infer the vcpu id from the kvm_entry tracepoints, no?

> - add kvm_mmio_done to trace the time when mmio/ioport emulation is completed

ditto?


Relying on the existing tracepoints will make the tool work on older
kernels.


-- 
error compiling committee.c: too many arguments to function

