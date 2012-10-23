Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934059Ab2JWUMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:12:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44014 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936Ab2JWUMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:12:14 -0400
Date: Tue, 23 Oct 2012 16:12:13 -0400 (EDT)
Message-Id: <20121023.161213.1727234792900753255.davem@davemloft.net>
To: keescook@chromium.org
Cc: linux-kernel@vger.kernel.org, cesarb@cesarb.net
Subject: Re: [PATCH 090/193] drivers/net/ethernet/silan: remove
 CONFIG_EXPERIMENTAL
From: David Miller <davem@davemloft.net>
In-Reply-To: <1351022666-6960-91-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	<1351022666-6960-91-git-send-email-keescook@chromium.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Date: Tue, 23 Oct 2012 13:02:43 -0700

> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
> 
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Cesar Eduardo Barros <cesarb@cesarb.net>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: David S. Miller <davem@davemloft.net>
