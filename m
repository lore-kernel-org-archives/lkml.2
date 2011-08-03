Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab1HCJkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 05:40:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab1HCJkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 05:40:40 -0400
Message-ID: <4E391793.8090406@redhat.com>
Date: Wed, 03 Aug 2011 12:40:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 02/12] KVM: x86: tag the instructions which are used
 to write page table
References: <4E37DA49.1040000@cn.fujitsu.com> <4E37DA73.7010908@cn.fujitsu.com> <4E37EB8E.6080207@redhat.com> <4E38E477.2000208@cn.fujitsu.com> <4E39021F.8070508@redhat.com> <4E3913CC.7010907@cn.fujitsu.com> <4E391417.6050503@redhat.com> <4E3917DC.9040902@cn.fujitsu.com>
In-Reply-To: <4E3917DC.9040902@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2011 12:41 PM, Xiao Guangrong wrote:
> OK. :-)
>
> Um, how about cache the last eip when we do this optimization, if we meet the same eip, we
> can break out the potential infinite loop?

Yes, that can work.


-- 
error compiling committee.c: too many arguments to function

