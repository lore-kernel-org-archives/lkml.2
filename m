Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab0EXHWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 03:22:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40021
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755808Ab0EXHWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 03:22:37 -0400
Date: Mon, 24 May 2010 00:22:47 -0700 (PDT)
Message-Id: <20100524.002247.76114229.davem@davemloft.net>
To: ruirui.r.yang@tieto.com
Cc: mostrows@earthlink.net, linux-kernel@vger.kernel.org,
       hidave.darkstar@gmail.com
Subject: Re: [PATCH] pppoe: initilize pppoe_pernet before usage
From: David Miller <davem@davemloft.net>
In-Reply-To: <201005241519.47159.ruirui.r.yang@tieto.com>
References: <201005241519.47159.ruirui.r.yang@tieto.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang Ruirui <ruirui.r.yang@tieto.com>
Date: Mon, 24 May 2010 15:19:46 +0800

> ifconfig eth0 down in my kvm guest cause following oops, it's due to pppoe_net in
> pppoe_flush_dev is not initilized:

I have this fix in my net-2.6 tree already.

Thanks!
