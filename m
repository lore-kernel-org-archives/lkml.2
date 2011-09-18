Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab1IRDdl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 23:33:41 -0400
Received: from mx2.parallels.com ([64.131.90.16]:56965 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831Ab1IRDdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 23:33:38 -0400
Message-ID: <4E756666.9000009@parallels.com>
Date: Sun, 18 Sep 2011 00:32:54 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: "Kirill A. Shutemov" <kirill@shutemov.name>,
        <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <ebiederm@xmission.com>, <davem@davemloft.net>, <gthelen@google.com>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH v2 4/7] per-cgroup tcp buffers control
References: <1316051175-17780-1-git-send-email-glommer@parallels.com> <1316051175-17780-5-git-send-email-glommer@parallels.com> <20110917181132.GC1658@shutemov.name> <20110917183358.GB2783@moon>
In-Reply-To: <20110917183358.GB2783@moon>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.106.51.14]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2011 03:33 PM, Cyrill Gorcunov wrote:
> On Sat, Sep 17, 2011 at 09:11:32PM +0300, Kirill A. Shutemov wrote:
>> On Wed, Sep 14, 2011 at 10:46:12PM -0300, Glauber Costa wrote:
>>> +int tcp_init_cgroup_fill(struct proto *prot, struct cgroup *cgrp,
>>> +			 struct cgroup_subsys *ss)
>>> +{
>>> +	prot->enter_memory_pressure	= tcp_enter_memory_pressure;
>>> +	prot->memory_allocated		= memory_allocated_tcp;
>>> +	prot->prot_mem			= tcp_sysctl_mem;
>>> +	prot->sockets_allocated		= sockets_allocated_tcp;
>>> +	prot->memory_pressure		= memory_pressure_tcp;
>>
>> No fancy formatting, please.
>>
>
> What's wrong with having fancy formatting? It's indeed easier to read
> when members are assigned this way. It's always up to maintainer to
> choose what he prefers, but I see nothing wrong in such style (if only it
> doesn't break the style of the whole file).
>
> 	Cyrill


I am in agreement with Cyrill, but I really, really don't care...
