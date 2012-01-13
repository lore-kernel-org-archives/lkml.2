Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab2AMEG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 23:06:28 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:43779 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab2AMEG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 23:06:26 -0500
Date: Thu, 12 Jan 2012 20:06:18 -0800 (PST)
Message-Id: <20120112.200618.1500624575730438380.davem@davemloft.net>
To: despite@gmail.com
Cc: xeb@mail.ru, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pptp: Accept packet with seq zero
From: David Miller <davem@davemloft.net>
In-Reply-To: <1326400756-14021-1-git-send-email-despite@gmail.com>
References: <1326400756-14021-1-git-send-email-despite@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 12 Jan 2012 20:06:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bradley Peterson <despite@gmail.com>
Date: Thu, 12 Jan 2012 14:39:16 -0600

> Initialize the PPTP "seq received" value to 0xffffffff, so we don't
> ignore packets with seq zero.
> 
> Signed-off-by: Bradley Peterson <despite@gmail.com>

Applied.
