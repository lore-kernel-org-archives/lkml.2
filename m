Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab0KAN4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 09:56:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38958
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756390Ab0KAN4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 09:56:05 -0400
Date: Mon, 01 Nov 2010 06:56:28 -0700 (PDT)
Message-Id: <20101101.065628.104045417.davem@davemloft.net>
To: linux@treblig.org
Cc: linux-kernel@vger.kernel.org, jchapman@katalix.com, netdev@vger.kernel.org
Subject: Re: [PATCH] kzalloc with swapped params in l2tp_dfs_seq_open
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101031172603.GB16459@gallifrey>
References: <20101031172603.GB16459@gallifrey>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Dr. David Alan Gilbert" <linux@treblig.org>
Date: Sun, 31 Oct 2010 17:26:03 +0000

> Hi,
>   'sparse' spotted that the parameters to kzalloc in l2tp_dfs_seq_open
> were swapped.
> 
> Tested on current git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> at 1792f17b7210280a3d7ff29da9614ba779cfcedb  build, boots and I can see that directory,
> but there again I could see /sys/kernel/debug/l2tp with it swapped; I don't have
> any l2tp in use.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>

Applied, thank you.
