Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776Ab2JaRXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:23:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47407 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab2JaRXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:23:22 -0400
Date: Wed, 31 Oct 2012 13:23:20 -0400 (EDT)
Message-Id: <20121031.132320.161133126258025586.davem@davemloft.net>
To: Claudio.Fontana@huawei.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend 2] net/ipv4/ipconfig: add device address to a
 KERN_INFO message
From: David Miller <davem@davemloft.net>
In-Reply-To: <50891F5F.7060003@huawei.com>
References: <50891F5F.7060003@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Claudio Fontana <Claudio.Fontana@huawei.com>
Date: Thu, 25 Oct 2012 13:15:43 +0200

> adds a "hwaddr" to the "IP-Config: Complete" KERN_INFO message
> with the dev_addr of the device selected for auto configuration.
> 
> Signed-off-by: Claudio Fontana <claudio.fontana@huawei.com>

Applied to net-next
