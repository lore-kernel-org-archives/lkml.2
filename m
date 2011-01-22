Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab1AVAX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 19:23:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43416
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754894Ab1AVAX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 19:23:58 -0500
Date: Fri, 21 Jan 2011 16:24:32 -0800 (PST)
Message-Id: <20110121.162432.77330574.davem@davemloft.net>
To: segoon@openwall.com
Cc: kernel-janitors@vger.kernel.org, chas@cmf.nrl.navy.mil,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: idt77105: fix fetch_stats() result
From: David Miller <davem@davemloft.net>
In-Reply-To: <1295602987-11688-1-git-send-email-segoon@openwall.com>
References: <1295602987-11688-1-git-send-email-segoon@openwall.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segoon@openwall.com>
Date: Fri, 21 Jan 2011 12:43:07 +0300

> copy_to_user() used PRIV(dev)->stats instead of local stats variable.
> Zero stats were returned to user in case of (zero != 0), also memcpy()
> was pointless.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

Applied, thanks.
