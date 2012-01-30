Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab2A3DOG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 22:14:06 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62512 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab2A3DOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 22:14:04 -0500
Message-ID: <4F260AEF.9020900@gmail.com>
Date: Mon, 30 Jan 2012 11:13:51 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] netpoll: Convert printks to np_<level> and
 add pr_fmt
References: <8a61df72a4eb6caaeaa8b5be644be227da61512b.1327888082.git.joe@perches.com>
In-Reply-To: <8a61df72a4eb6caaeaa8b5be644be227da61512b.1327888082.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2012 09:50 AM, Joe Perches wrote:
> Use a more current message logging style.
> Add pr_fmt to prefix dmesg output with "netpoll: "
> Add macros to print np->name.
>
> Signed-off-by: Joe Perches<joe@perches.com>

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.

