Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab2LKEoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 23:44:04 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34646 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab2LKEoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 23:44:01 -0500
Date: Mon, 10 Dec 2012 23:43:58 -0500 (EST)
Message-Id: <20121210.234358.788502498079611342.davem@davemloft.net>
To: abhi.c.pawar@gmail.com
Cc: amwang@redhat.com, joe@perches.com, jmorris@namei.org, edumazet@google.com,
        pablo@netfilter.org, kaber@trash.net, coreteam@netfilter.org,
        yoshfuji@linux-ipv6.org, netfilter-devel@vger.kernel.org,
        johannes@sipsolutions.net, linux-kernel@vger.kernel.org,
        netfilter@vger.kernel.org, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, kuznet@ms2.inr.ac.ru
Subject: Re: [PATCH RESEND] net: remove obsolete simple_strto<foo>
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+kxV1GBxdZKnjqs1bm1qBJE8dGXtOfqP_oYbB-hw5Ga1xE65g@mail.gmail.com>
References: <1355130748-7828-1-git-send-email-abhi.c.pawar@gmail.com>
	<20121210.141002.450030380391247897.davem@davemloft.net>
	<CA+kxV1GBxdZKnjqs1bm1qBJE8dGXtOfqP_oYbB-hw5Ga1xE65g@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijit Pawar <abhi.c.pawar@gmail.com>
Date: Tue, 11 Dec 2012 06:36:59 +0530

> It looks like there are two occurences of simple_strtoul which has not been
> removed cleanly from the patch.
> They are in netpoll.c and debugfs_sta.c
> I will send the modified corrected clean patch shortly.

You can't simply send me a replacement patch, since I already applied
the original one and that patch will not be reverted.
