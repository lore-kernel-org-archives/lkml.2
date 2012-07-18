Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab2GRQrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 12:47:31 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35868 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab2GRQr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 12:47:27 -0400
Date: Wed, 18 Jul 2012 09:47:26 -0700 (PDT)
Message-Id: <20120718.094726.1297357353181354474.davem@davemloft.net>
To: cmetcalf@tilera.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] net: various tilegx networking fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <201207181640.q6IGet7P007227@lab-41.internal.tilera.com>
References: <201207181640.q6IGet7P007227@lab-41.internal.tilera.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please don't post patches like you did here.

The big problem is that you use the dates of your commit in
the email, that breaks everything.

It makes the patches appear out of order in patchwork, which make
more work for me.

Please repost these patches, and tell git-am or whatever tool you use
to not use the commit date in the outgoing emails.

THanks.
