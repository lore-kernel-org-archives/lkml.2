Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870Ab1DYSzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 14:55:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53970
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758847Ab1DYSzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 14:55:04 -0400
Date: Mon, 25 Apr 2011 11:54:29 -0700 (PDT)
Message-Id: <20110425.115429.193701951.davem@davemloft.net>
To: berny156@gmx.de
Cc: eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: Oops in 2.6.39 include/net/dst.h: dst_metrics_write_ptr()
 running l2tp over ipsec
From: David Miller <davem@davemloft.net>
In-Reply-To: <4DB54450.90806@gmx.de>
References: <4DB4A619.9080600@gmx.de>
	<1303718852.2747.103.camel@edumazet-laptop>
	<4DB54450.90806@gmx.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Held Bernhard <berny156@gmx.de>
Date: Mon, 25 Apr 2011 11:52:16 +0200

> Am 25.04.2011 10:07, schrieb Eric Dumazet:
>> From: Held Bernhard<berny156@gmx.de>
 ...
>> Thanks for your report and patch.
>>
>> Maybe following patch is the way to fix this, please test it.
>>
>>
>> [PATCH] net: provide cow_metrics() methods to blackhole dst_ops
 ...
>> The oops happens in dst_metrics_write_ptr()
>> include/net/dst.h:124: return dst->ops->cow_metrics(dst, p);
>>
>> dst->ops->cow_metrics is NULL and causes the oops.
>>
>> Provide cow_metrics() methods, like we did in commit 214f45c91bb
>> (net: provide default_advmss() methods to blackhole dst_ops)
>>
>> Signed-off-by: Held Bernhard<berny156@gmx.de>
>> Signed-off-by: Eric Dumazet<eric.dumazet@gmail.com>
 ...
> Your patch works flawlessly.
> 
> Thanks for the quick response!

Applied, thanks everyone.
