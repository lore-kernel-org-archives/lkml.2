Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab0HBJxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 05:53:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab0HBJxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 05:53:49 -0400
Message-ID: <4C5695A8.4020600@redhat.com>
Date: Mon, 02 Aug 2010 12:53:44 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] KVM: MMU: using kvm_set_pfn_accessed() instead
 of mark_page_accessed()
References: <4C4E5313.1080308@cn.fujitsu.com> <4C567DD8.5050101@cn.fujitsu.com>
In-Reply-To: <4C567DD8.5050101@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/02/2010 11:12 AM, Xiao Guangrong wrote:
> It's a small cleanup that using using kvm_set_pfn_accessed() instead
> of mark_page_accessed()

Applied all of v2, thanks.

-- 
error compiling committee.c: too many arguments to function

