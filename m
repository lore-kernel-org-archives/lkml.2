Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab2GQFXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 01:23:52 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46098 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab2GQFXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 01:23:50 -0400
Date: Mon, 16 Jul 2012 22:23:48 -0700 (PDT)
Message-Id: <20120716.222348.382977548581101928.davem@davemloft.net>
To: avagin@openvz.org
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, xemul@parallels.com, eric.dumazet@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net-next: make sock diag per-namespace (v2)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1342448929-1809316-1-git-send-email-avagin@openvz.org>
References: <1342448929-1809316-1-git-send-email-avagin@openvz.org>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Vagin <avagin@openvz.org>
Date: Mon, 16 Jul 2012 18:28:49 +0400

> Before this patch sock_diag works for init_net only and dumps
> information about sockets from all namespaces.
> 
> This patch expands sock_diag for all name-spaces.
> It creates a netlink kernel socket for each netns and filters
> data during dumping.
> 
> v2: filter accoding with netns in all places
>     remove an unused variable.
> 
> Signed-off-by: Andrew Vagin <avagin@openvz.org>

Applied, thanks.
