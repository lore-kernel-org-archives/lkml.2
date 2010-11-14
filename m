Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab0KNKwY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 05:52:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097Ab0KNKwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 05:52:22 -0500
Message-ID: <4CDFBF5B.10706@redhat.com>
Date: Sun, 14 Nov 2010 12:52:11 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/4] KVM: MMU: don't drop spte if overwrite it from W
 to RO
References: <4CDD173E.8010706@cn.fujitsu.com>
In-Reply-To: <4CDD173E.8010706@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2010 12:30 PM, Xiao Guangrong wrote:
> We just need flush tlb if overwrite a writable spte with a read-only one
>

What are the advantages?  Avoid playing with rmap, and avoid a window 
where the spte is missing?

(they are worth the patch, just seeing if I'm not missing something)

-- 
error compiling committee.c: too many arguments to function

