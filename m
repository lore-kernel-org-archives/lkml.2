Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab2LSUvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 15:51:14 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49448 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab2LSUvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 15:51:06 -0500
Date: Wed, 19 Dec 2012 12:51:05 -0800 (PST)
Message-Id: <20121219.125105.474504972221301066.davem@davemloft.net>
To: dinggnu@gmail.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: addrconf.c: remove unnecessary "if"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1355868536-1622-1-git-send-email-dinggnu@gmail.com>
References: <1355868536-1622-1-git-send-email-dinggnu@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Ding <dinggnu@gmail.com>
Date: Tue, 18 Dec 2012 23:08:56 +0100

> the value of err is always negative if it goes to errout, so we don't need to
> check the value of err.
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>

Applied.
