Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab0GFCG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 22:06:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48245
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757028Ab0GFCGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 22:06:22 -0400
Date: Mon, 05 Jul 2010 19:06:35 -0700 (PDT)
Message-Id: <20100705.190635.245412428.davem@davemloft.net>
To: segooon@gmail.com
Cc: kernel-janitors@vger.kernel.org, joe@perches.com, jpirko@redhat.com,
       shemminger@vyatta.com, adobriyan@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] epic100: Use the instance of net_device_stats from
 net_device.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1278332002-15860-1-git-send-email-segooon@gmail.com>
References: <1278332002-15860-1-git-send-email-segooon@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kulikov Vasiliy <segooon@gmail.com>
Date: Mon,  5 Jul 2010 16:13:20 +0400

> Since net_device has an instance of net_device_stats,
> we can remove the instance of this from the adapter structure.
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

Applied.
