Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197Ab0DML6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 07:58:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab0DML6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 07:58:31 -0400
Message-ID: <4BC45C63.2010307@redhat.com>
Date: Tue, 13 Apr 2010 14:58:27 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] KVM MMU: optimize/cleanup for marking parent unsync
References: <4BC2D2E2.1030604@cn.fujitsu.com> <4BC2D390.7050708@cn.fujitsu.com> <20100412171211.GC4976@amt.cnet> <4BC3CE83.8020705@cn.fujitsu.com>
In-Reply-To: <4BC3CE83.8020705@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2010 04:53 AM, Xiao Guangrong wrote:
>
>> I'd prefer to not touch it.
>>      
> This patch avoids walk all parents and i think this overload is really unnecessary.
> It has other tricks in this codepath but i not noticed? :-)
>    

There is also the advantage of code size reduction.

-- 
error compiling committee.c: too many arguments to function

