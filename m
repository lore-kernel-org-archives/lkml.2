Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab2FFQlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:41:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37204 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab2FFQlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:41:36 -0400
Date: Wed, 06 Jun 2012 09:41:35 -0700 (PDT)
Message-Id: <20120606.094135.768228524411466462.davem@davemloft.net>
To: cmetcalf@tilera.com
Cc: bhutchings@solarflare.com, arnd@arndb.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v9] tilegx network driver: initial support
From: David Miller <davem@davemloft.net>
In-Reply-To: <201206042023.q54KNEZp003834@farm-0002.internal.tilera.com>
References: <20120524.003148.700603156196416506.davem@davemloft.net>
	<201205251853.q4PIrE7T000723@lab-41.internal.tilera.com>
	<201206042023.q54KNEZp003834@farm-0002.internal.tilera.com>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 4 Jun 2012 16:12:03 -0400

> This change adds support for the tilegx network driver based on the
> GXIO IORPC support in the tilegx software stack, using the on-chip
> mPIPE packet processing engine.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
> This change fixes some bugs that were discovered during additional
> testing of the TSO refactoring.  In addition, I added a comment
> explaining why we provide TSO support as essentially driver-side GSO.
> 
> The previous v8 version of the patch (from 10 days ago) received no
> feedback; if anyone would care to provide feedback on this version of
> the driver, it would be much appreciated.  Thanks!

Someone other than me please review this driver.
