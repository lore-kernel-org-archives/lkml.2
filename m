Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab0GFBzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 21:55:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36458
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753699Ab0GFBzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 21:55:52 -0400
Date: Mon, 05 Jul 2010 18:56:06 -0700 (PDT)
Message-Id: <20100705.185606.115922440.davem@davemloft.net>
To: ralf@linux-mips.org
Cc: segooon@gmail.com, kernel-janitors@vger.kernel.org, jpirko@redhat.com,
       eric.dumazet@gmail.com, kaber@trash.net, adobriyan@gmail.com,
       linux-mips@linux-mips.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [NET] ioc3-eth: Use the instance of net_device_stats from
 net_device.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100705125938.GB28849@linux-mips.org>
References: <20100705125938.GB28849@linux-mips.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ralf Baechle <ralf@linux-mips.org>
Date: Mon, 5 Jul 2010 13:59:38 +0100

> Since net_device has an instance of net_device_stats, we can remove the
> instance of this from the adapter structure.
> 
> Based on original patch by Kulikov Vasiliy.
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

Applied.
