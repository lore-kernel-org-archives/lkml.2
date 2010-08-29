Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab0H2JIc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 05:08:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab0H2JIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 05:08:30 -0400
Message-ID: <4C7A2389.8080606@redhat.com>
Date: Sun, 29 Aug 2010 12:08:25 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/5] KVM: MMU: some bugfix for mmu audit code
References: <4C78F07E.1040709@cn.fujitsu.com>
In-Reply-To: <4C78F07E.1040709@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/28/2010 02:18 PM, Xiao Guangrong wrote:
> There are some bugfix patches for mmu audit code:
>
> [PATCH 1/5] KVM: MMU: fix compile warning in audit code
> [PATCH 2/5] KVM: MMU: check rmap for every spte
> [PATCH 3/5] KVM: MMU: fix wrong not write protected sp report
> [PATCH 4/5] KVM: MMU: rewrite audit_mappings_page() function
> [PATCH 5/5] KVM: MMU: remove count_rmaps()

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

