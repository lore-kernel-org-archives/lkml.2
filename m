Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab1DRA5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 20:57:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33759
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752320Ab1DRA5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 20:57:30 -0400
Date: Sun, 17 Apr 2011 17:56:55 -0700 (PDT)
Message-Id: <20110417.175655.63020877.davem@davemloft.net>
To: joe@perches.com
Cc: mr.nuke.me@gmail.com, rl@hellgate.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] via_rhine: Use netdev_<level> and pr_<level>
From: David Miller <davem@davemloft.net>
In-Reply-To: <15b0ca3fc5ba6a16b207fb32b0c2e3c809f376d1.1302998994.git.joe@perches.com>
References: <4DAA12C0.7030106@gmail.com>
	<cover.1302998994.git.joe@perches.com>
	<15b0ca3fc5ba6a16b207fb32b0c2e3c809f376d1.1302998994.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sat, 16 Apr 2011 17:15:25 -0700

> Use the more current logging styles.
> 
> Add #define DEBUG to make netdev_dbg always active.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
