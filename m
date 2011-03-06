Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab1CFMfK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 07:35:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451Ab1CFMfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 07:35:06 -0500
Message-ID: <4D737F72.2070804@redhat.com>
Date: Sun, 06 Mar 2011 14:34:58 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/10] KVM: MMU: fix kvm_mmu_slot_remove_write_access
References: <4D70C569.1030107@cn.fujitsu.com>
In-Reply-To: <4D70C569.1030107@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2011 12:56 PM, Xiao Guangrong wrote:
> Only remove write access in the last sptes

Thanks, applied patches 1, 3, 5, 6, 8, and 9.

-- 
error compiling committee.c: too many arguments to function

