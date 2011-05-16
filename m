Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab1EPSya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:54:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35913
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751567Ab1EPSy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:54:29 -0400
Date: Mon, 16 May 2011 11:53:57 -0700 (PDT)
Message-Id: <20110516.115357.193701317.davem@davemloft.net>
To: kosaki.motohiro@jp.fujitsu.com
Cc: linux-kernel@vger.kernel.org, therbert@google.com, eric.dumazet@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: cpuvert to new cpumask API
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110428235813.3D5A.A69D9226@jp.fujitsu.com>
References: <20110428235813.3D5A.A69D9226@jp.fujitsu.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 28 Apr 2011 23:56:35 +0900 (JST)

> We plan to remove cpu_xx() old api later. Thus this patch
> convert it.
> 
> This patch has no functional change.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Applied, thanks.
