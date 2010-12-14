Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab0LNI41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 03:56:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700Ab0LNI40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 03:56:26 -0500
Message-ID: <4D073133.1020709@redhat.com>
Date: Tue, 14 Dec 2010 10:56:19 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: MMU: don't make direct sp read-only if !map_writable
References: <4D05F5F6.3070909@cn.fujitsu.com> <4D05F62D.9040308@redhat.com> <4D06CE19.9000908@cn.fujitsu.com>
In-Reply-To: <4D06CE19.9000908@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2010 03:53 AM, Xiao Guangrong wrote:
> >  I just sent a patch to fix this in a different way, please review it.
> >
>
> Your patch is good for me, please ignore this one :-)
>
> Umm, do we need move "access&= ~ACC_WRITE_MASK" into set_spte() then
> can remove the same code in the caller?

I guess set_spte() is the better place for this.

-- 
error compiling committee.c: too many arguments to function

