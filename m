Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab1G0JIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:08:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab1G0JIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:08:13 -0400
Message-ID: <4E2FD578.2090803@redhat.com>
Date: Wed, 27 Jul 2011 12:08:08 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 04/11] KVM: MMU: do not mark access bit on pte write path
References: <4E2EA3DB.7040403@cn.fujitsu.com> <4E2EA4C8.5010103@cn.fujitsu.com>
In-Reply-To: <4E2EA4C8.5010103@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2011 02:28 PM, Xiao Guangrong wrote:
> In current code, the accessed bit is always set when page fault occurred,
> do not need to set it on pte write path
>

Is this true? a write with pte.w=pte.a=0 sets pte.a?

-- 
error compiling committee.c: too many arguments to function

