Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab0LZDl4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 22:41:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34850
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751841Ab0LZDlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 22:41:50 -0500
Date: Sat, 25 Dec 2010 19:42:20 -0800 (PST)
Message-Id: <20101225.194220.189701956.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: soete.joel@scarlet.be, eric.dumazet@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-2.6 v2] epic100: hamachi: yellowfin: Fix skb
 allocation size
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101225173959.GB2264@del.dom.local>
References: <4D15F6C9.50700@scarlet.be>
	<20101225151217.GA1994@del.dom.local>
	<20101225173959.GB2264@del.dom.local>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Sat, 25 Dec 2010 18:39:59 +0100

> Joel Soete reported oopses during pppoe over sundance NIC, caused by
> a bug in skb allocation and dma mapping code, where skb_reserve()
> bytes weren't taken into account. As a followup to the patch:
> "sundance: Fix oopses with corrupted skb_shared_info" very similar
> code is fixed here for three other drivers.
> 
> Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>

Also applied, thanks.
