Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab1IMKx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 06:53:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444Ab1IMKxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 06:53:55 -0400
Message-ID: <4E6F363E.9080000@redhat.com>
Date: Tue, 13 Sep 2011 13:53:50 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 05/11] KVM: MMU: do not mark accessed bit on pte write
 path
References: <4E5C4C20.3000403@cn.fujitsu.com> <4E5C4C8D.5040509@cn.fujitsu.com>
In-Reply-To: <4E5C4C8D.5040509@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2011 05:35 AM, Xiao Guangrong wrote:
> In current code, the accessed bit is always set when page fault occurred,
> do not need to set it on pte write path

What about speculative sptes that are then only accessed via emulation?

-- 
error compiling committee.c: too many arguments to function

