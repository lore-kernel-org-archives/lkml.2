Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab0CYM4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 08:56:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63052 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab0CYM4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 08:56:17 -0400
Message-ID: <4BAB5D7F.5010401@cn.fujitsu.com>
Date: Thu, 25 Mar 2010 20:56:31 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>, David Rientjes <rientjes@google.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH V2 4/4] cpuset,mm: update task's mems_allowed lazily
References: <4B94CD2D.8070401@cn.fujitsu.com> <alpine.DEB.2.00.1003081330370.18502@chino.kir.corp.google.com> <4B95F802.9020308@cn.fujitsu.com> <20100311081548.GJ5812@laptop> <4B98C6DE.3060602@cn.fujitsu.com> <20100311110317.GL5812@laptop> <4BAB39B9.7080600@cn.fujitsu.com>
In-Reply-To: <4BAB39B9.7080600@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2010-3-25 18:23, Miao Xie wrote:
> on 2010-3-11 19:03, Nick Piggin wrote:
>> Well... I do think seqlocks would be a bit simpler because they don't
>> require this checking and synchronizing of this patch.
> 
> Hi, Nick Piggin
> 
> I have made a new patch which uses seqlock to protect mems_allowed and mempolicy.
> please review it.
> 
> title: [PATCH -mmotm] cpuset,mm: use seqlock to protect task->mempolicy and mems_allowed
> 

Sorry! Please ignore this patch, because I sent an old version. I'll send the new one later.

Regards!
Miao

