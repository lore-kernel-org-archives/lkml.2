Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab1BVO1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:27:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587Ab1BVO07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:26:59 -0500
Message-ID: <4D63C7AE.6040108@redhat.com>
Date: Tue, 22 Feb 2011 16:26:54 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/7] KVM: cache the last used slot
References: <4D636EF8.60800@cn.fujitsu.com> <4D637019.9070208@cn.fujitsu.com>
In-Reply-To: <4D637019.9070208@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 10:13 AM, Xiao Guangrong wrote:
> Cache the last used slot, the hit ratio is more than 35% during my test
>

If we sort the slots by size, or use a weighted balanced tree, this 
should come for free.

-- 
error compiling committee.c: too many arguments to function

