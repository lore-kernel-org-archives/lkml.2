Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab2DPLsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 07:48:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189Ab2DPLsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 07:48:01 -0400
Message-ID: <4F8C06ED.6020805@redhat.com>
Date: Mon, 16 Apr 2012 14:47:57 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 10/16] KVM: MMU: fask check whether page is writable
References: <4F87FA69.5060106@linux.vnet.ibm.com> <4F87FC82.2050302@linux.vnet.ibm.com> <4F8AE64F.7080909@redhat.com> <4F8B9115.2030807@linux.vnet.ibm.com> <4F8BEE1B.8000704@redhat.com> <4F8BF265.7020405@linux.vnet.ibm.com>
In-Reply-To: <4F8BF265.7020405@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 01:20 PM, Xiao Guangrong wrote:
> >>
> >> It is used to avoid the unnecessary overload 
> > 
> > It's overloading me :(
> > 
>
>
> Sorry.
>

The trick is to send those in separate patchset so the maintainer
doesn't notice.

-- 
error compiling committee.c: too many arguments to function

