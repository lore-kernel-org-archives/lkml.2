Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab1GNI7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 04:59:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab1GNI7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 04:59:17 -0400
Message-ID: <4E1EAFDD.1080406@redhat.com>
Date: Thu, 14 Jul 2011 11:59:09 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/3] KVM: x86: fix broken read emulation spans a page
 boundary
References: <4E1D3BAC.5090109@cn.fujitsu.com>
In-Reply-To: <4E1D3BAC.5090109@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2011 09:31 AM, Xiao Guangrong wrote:
> If the range spans a page boundary, the mmio access can be broke, fix it as
> write emulation.
>
> And we already get the guest physical address, so use it to read guest data
> directly to avoid walking guest page table again

Applied all, thanks.

-- 
error compiling committee.c: too many arguments to function

