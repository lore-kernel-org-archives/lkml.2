Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab2A3LSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 06:18:49 -0500
Received: from mx2.parallels.com ([64.131.90.16]:47059 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135Ab2A3LSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 06:18:48 -0500
Message-ID: <4F267C61.9090802@parallels.com>
Date: Mon, 30 Jan 2012 15:17:53 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/tcp: Fix tcp memory limits initialization when !CONFIG_SYSCTL
References: <20120127142246.GA22318@elte.hu> <4F22B634.2020007@parallels.com> <4F22D05A.8030604@parallels.com> <20120127.162823.1960229872591588915.davem@davemloft.net> <4F231703.4040803@parallels.com> <20120128115028.GA14020@elte.hu>
In-Reply-To: <20120128115028.GA14020@elte.hu>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2012 03:50 PM, Ingo Molnar wrote:
>
> ok, the patch works fine - in the tested version i've renamed
> the function and cleaned up the changelog a bit, see the final
> patch below.
>
> Thanks,
>
> 	Ingo
>
Thank you Ingo.

will submit this patch now, then.
