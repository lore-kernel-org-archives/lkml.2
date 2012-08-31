Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab2HaT5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 15:57:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53007 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab2HaT5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 15:57:32 -0400
Date: Fri, 31 Aug 2012 15:57:30 -0400 (EDT)
Message-Id: <20120831.155730.665786534434857698.davem@davemloft.net>
To: xi.wang@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] af_unix: fix shutdown parameter checking
From: David Miller <davem@davemloft.net>
In-Reply-To: <1346035633-2492-1-git-send-email-xi.wang@gmail.com>
References: <1346035633-2492-1-git-send-email-xi.wang@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xi Wang <xi.wang@gmail.com>
Date: Sun, 26 Aug 2012 22:47:13 -0400

> Return -EINVAL rather than 0 given an invalid "mode" parameter.
> 
> Signed-off-by: Xi Wang <xi.wang@gmail.com>

Applied to net-next
