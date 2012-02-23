Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab2BWV75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 16:59:57 -0500
Received: from seven.medozas.de ([188.40.89.202]:35264 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab2BWV74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 16:59:56 -0500
Date: Thu, 23 Feb 2012 22:59:54 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] treewide: fix memory corruptions when TASK_COMM_LEN
 != 16
In-Reply-To: <20120223093027.7dfc90e3.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.2.01.1202232256180.15517@frira.zrqbmnf.qr>
References: <1327183785-27023-1-git-send-email-jengelh@medozas.de> <20120124135443.2772d455.akpm@linux-foundation.org> <alpine.LNX.2.01.1201250121260.20692@frira.zrqbmnf.qr> <20120131172334.7f26f164.akpm@linux-foundation.org> <alpine.LNX.2.01.1202010224510.29848@frira.zrqbmnf.qr>
 <20120131174914.8ce5291d.akpm@linux-foundation.org> <alpine.LNX.2.01.1202010257240.29848@frira.zrqbmnf.qr> <20120131190109.b53347fd.akpm@linux-foundation.org> <alpine.LNX.2.01.1202221343530.10125@frira.zrqbmnf.qr> <20120222125810.50cd5789.akpm@linux-foundation.org>
 <alpine.LNX.2.01.1202222303190.15465@frira.zrqbmnf.qr> <20120223015726.cb065d73.akpm@linux-foundation.org> <alpine.LNX.2.01.1202231152280.9220@frira.zrqbmnf.qr> <20120223093027.7dfc90e3.akpm@linux-foundation.org>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2012-02-23 18:30, Andrew Morton wrote:
>
>Teach ps(1) to look in /proc/pid/status for kernel threads?

To what end? The name in /proc/pid/status was also limited to
TASK_COMM_LEN.
