Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab2FDSLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 14:11:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43191 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab2FDSLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 14:11:49 -0400
Date: Mon, 04 Jun 2012 14:11:46 -0400 (EDT)
Message-Id: <20120604.141146.798909958558510549.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: [PATCH] net/hyperv: Use wait_event on outstanding sends during
 device removal
From: David Miller <davem@davemloft.net>
In-Reply-To: <1338828158-3133-1-git-send-email-haiyangz@microsoft.com>
References: <1338828158-3133-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Mon,  4 Jun 2012 09:42:38 -0700

> Change the busy-waiting/udelay to wait_event on outstanding sends.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Applied.
