Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab1C1BNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 21:13:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39900
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752553Ab1C1BNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 21:13:18 -0400
Date: Sun, 27 Mar 2011 18:12:37 -0700 (PDT)
Message-Id: <20110327.181237.48513830.davem@davemloft.net>
To: amwang@redhat.com
Cc: linux-kernel@vger.kernel.org, eric.dumazet@gmail.com, xiaosuo@gmail.com,
        therbert@google.com, jesse@nicira.com, netdev@vger.kernel.org
Subject: Re: [Patch] net: remove useless comments in net/core/dev.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1300795189-24655-1-git-send-email-amwang@redhat.com>
References: <1300795189-24655-1-git-send-email-amwang@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amerigo Wang <amwang@redhat.com>
Date: Tue, 22 Mar 2011 19:59:47 +0800

> The code itself can explain what it is doing, no need these comments.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>

Agreed, these comments are superfluous, applied thanks!
