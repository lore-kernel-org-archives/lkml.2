Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1F2Isc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 04:48:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750Ab1F2Is0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 04:48:26 -0400
Message-ID: <4E0AE6D5.6080205@redhat.com>
Date: Wed, 29 Jun 2011 11:48:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 07/22] KVM: MMU: cache mmio info on page fault path
References: <4E01FBC9.3020009@cn.fujitsu.com> <4E01FCA8.3050401@cn.fujitsu.com>
In-Reply-To: <4E01FCA8.3050401@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 05:31 PM, Xiao Guangrong wrote:
> If the page fault is caused by mmio, we can cache the mmio info, later, we do
> not need to walk guest page table and quickly know it is a mmio fault while we
> emulate the mmio instruction

Does this work if the mmio spans two pages?

-- 
error compiling committee.c: too many arguments to function

