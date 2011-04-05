Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab1DEIf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 04:35:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259Ab1DEIf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 04:35:27 -0400
Message-ID: <4D9AD449.5070304@redhat.com>
Date: Tue, 05 Apr 2011 11:35:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: MMU: remove mmu_seq verification on pte write
 path
References: <4D8FF287.1040300@cn.fujitsu.com>
In-Reply-To: <4D8FF287.1040300@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2011 04:29 AM, Xiao Guangrong wrote:
> The mmu_seq verification can be removed since we get the pfn in the
> protection of mmu_lock

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

