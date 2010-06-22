Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab0FVL4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 07:56:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab0FVL4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 07:56:09 -0400
Message-ID: <4C20A4D5.2090601@redhat.com>
Date: Tue, 22 Jun 2010 14:56:05 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [BUGFIX] kvm, Fix a race condition for usage of is_hwpoison_address
References: <1277187791.3004.149.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1277187791.3004.149.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2010 09:23 AM, Huang Ying wrote:
> is_hwpoison_address accesses the page table, so the caller must hold
> current->mm->mmap_sem in read mode. So fix its usage in hav_to_pfn of
> kvm accordingly.
>
>    

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

