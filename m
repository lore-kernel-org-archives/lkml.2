Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab2A0V3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:29:32 -0500
Received: from mx2.parallels.com ([64.131.90.16]:35057 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149Ab2A0V3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 16:29:30 -0500
Message-ID: <4F231703.4040803@parallels.com>
Date: Sat, 28 Jan 2012 01:28:35 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <mingo@elte.hu>, <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [v3.3-rc1 regression] TCP: too many of orphaned sockets
References: <20120127142246.GA22318@elte.hu> <4F22B634.2020007@parallels.com> <4F22D05A.8030604@parallels.com> <20120127.162823.1960229872591588915.davem@davemloft.net>
In-Reply-To: <20120127.162823.1960229872591588915.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.255.67.4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2012 01:28 AM, David Miller wrote:
> From: Glauber Costa<glommer@parallels.com>
> Date: Fri, 27 Jan 2012 20:27:06 +0400
>
>> +extern void init_tcp_mem(struct net *net);
>
> Please name this "tcp_init_mem" or similar, keeping all TCP functions
> globally exported with a "tcp_*" prefix.

Ok, will do.
