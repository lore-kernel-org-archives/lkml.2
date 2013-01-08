Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab3AHDlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 22:41:21 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49710 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab3AHDlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 22:41:20 -0500
Date: Mon, 07 Jan 2013 19:41:19 -0800 (PST)
Message-Id: <20130107.194119.904344091925634365.davem@davemloft.net>
To: joe@perches.com
Cc: divy@chelsio.com, dm@chelsio.com, leedom@chelsio.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] chelsio: Use netdev_<level> and pr_<level>
From: David Miller <davem@davemloft.net>
In-Reply-To: <1357515289.4940.6.camel@joe-AO722>
References: <1357515289.4940.6.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun, 06 Jan 2013 15:34:49 -0800

> Use more current logging styles.
> 
> Convert printks to pr_<level> and
> printks with ("%s: ...", dev->name to netdev_<level>(dev, "...
> 
> Add pr_fmt #defines where appropriate.
> Coalesce formats.
> Use pr_<level>_once where appropriate.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
