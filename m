Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab1HIQGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 12:06:06 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38550 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab1HIQGE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 12:06:04 -0400
MIME-Version: 1.0
In-Reply-To: <20110809.085049.747100276988072226.davem@davemloft.net>
References: <1312904711-1855-1-git-send-email-wangshaoyan.pt@taobao.com>
	<20110809.085049.747100276988072226.davem@davemloft.net>
Date: Wed, 10 Aug 2011 00:06:03 +0800
Message-ID: <CANxBZFq2VJ4os9zuFrm0qxU2MdGep92JP9bFggpX14F01OzH_A@mail.gmail.com>
Subject: Re: [PATCH] gianfar: reduce stack usage in gianfar_ethtool.c
From: Wang Shaoyan <stufever@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Sandeep.Kumar@freescale.com, wangshaoyan.pt@taobao.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for remainding, I just want to cover up my careless asap:-)

2011/8/9 David Miller <davem@davemloft.net>:
> From: stufever@gmail.com
> Date: Tue,  9 Aug 2011 23:45:11 +0800
>
>> From: Wang Shaoyan <wangshaoyan.pt@taobao.com>
>>
>>   drivers/net/gianfar_ethtool.c:765: warning: the frame size of 2048 bytes is larger than 1024 bytes
>>
>> Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
>
> Would you be so kind as to actually acknowledge in some way the person
> who found all the bugs in your first version of this patch? :-/
>
>



-- 
Wang Shaoyan
