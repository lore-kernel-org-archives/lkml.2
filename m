Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab1HDIoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 04:44:08 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:52447 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1HDIoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 04:44:06 -0400
Date: Thu, 04 Aug 2011 01:43:52 -0700 (PDT)
Message-Id: <20110804.014352.2136986087530764032.davem@davemloft.net>
To: tord.andersson@endian.se
Cc: nicolas.ferre@atmel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] macb: restore wrap bit when performing underrun cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <1312445507-31382-1-git-send-email-tord.andersson@endian.se>
References: <1312445507-31382-1-git-send-email-tord.andersson@endian.se>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 04 Aug 2011 01:43:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tord Andersson <tord.andersson@endian.se>
Date: Thu,  4 Aug 2011 10:11:47 +0200

> When TX underrun occurs, a cleanup is performed that marks all buffers as used. As a side effect it also clears the wrap bit in the last buffer. This patch will restore the wrap bit.
> 
> Signed-off-by: Tord Andersson <tord.andersson@endian.se>

Applied.
