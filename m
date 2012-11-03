Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab2KCTQA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 15:16:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57952 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab2KCTP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 15:15:58 -0400
Date: Sat, 03 Nov 2012 15:15:56 -0400 (EDT)
Message-Id: <20121103.151556.899752323466185527.davem@davemloft.net>
To: xtfeng@gmail.com
Cc: linux-kernel@vger.kernel.org, dannyfeng@tencent.com,
        jon.maloy@ericsson.com, allan.stephens@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH 3/3] tipc: do not use tasklet_disable before
 tasklet_kill
From: David Miller <davem@davemloft.net>
In-Reply-To: <1351670761-26749-3-git-send-email-xtfeng@gmail.com>
References: <1351670761-26749-1-git-send-email-xtfeng@gmail.com>
	<1351670761-26749-3-git-send-email-xtfeng@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiaotian Feng <xtfeng@gmail.com>
Date: Wed, 31 Oct 2012 16:06:01 +0800

> If tasklet_disable() is called before related tasklet handled,
> tasklet_kill will never be finished. tasklet_kill is enough.
> 
> Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>

Applied.
