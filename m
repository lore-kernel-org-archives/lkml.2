Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab2LJTKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:10:10 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58669 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab2LJTKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:10:06 -0500
Date: Mon, 10 Dec 2012 14:10:02 -0500 (EST)
Message-Id: <20121210.141002.450030380391247897.davem@davemloft.net>
To: abhi.c.pawar@gmail.com
Cc: pablo@netfilter.org, kaber@trash.net, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, linville@tuxdriver.com,
        johannes@sipsolutions.net, amwang@redhat.com, edumazet@google.com,
        nhorman@tuxdriver.com, joe@perches.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH RESEND] net: remove obsolete simple_strto<foo>
From: David Miller <davem@davemloft.net>
In-Reply-To: <1355130748-7828-1-git-send-email-abhi.c.pawar@gmail.com>
References: <1355130748-7828-1-git-send-email-abhi.c.pawar@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijit Pawar <abhi.c.pawar@gmail.com>
Date: Mon, 10 Dec 2012 14:42:28 +0530

> This patch replace the obsolete simple_strto<foo> with kstrto<foo>
> 
> Signed-off-by: Abhijit Pawar <abhi.c.pawar@gmail.com>

Applied.
