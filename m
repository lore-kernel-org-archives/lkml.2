Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765Ab2ECRHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 13:07:46 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45384 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661Ab2ECRHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 13:07:45 -0400
Date: Thu, 03 May 2012 13:07:38 -0400 (EDT)
Message-Id: <20120503.130738.203857602354001769.davem@davemloft.net>
To: cmetcalf@tilera.com
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3] tilegx network driver: initial support
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FA2A81C.8020402@tilera.com>
References: <201205011759.q41HxR21020043@farm-0012.internal.tilera.com>
	<20120503.014156.149171097979026872.davem@davemloft.net>
	<4FA2A81C.8020402@tilera.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 03 May 2012 10:07:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 3 May 2012 11:45:32 -0400

> Thanks, I've removed it from my branch.  (Since it's a trivial update, I
> won't repost the change on LKML unless I get any more feedback that needs
> addressing.)

Sorry, this approach doesn't work, you should post a new version
more expediently.

When I see something so terrible like I saw this time, I just provide
feedback on that major issue and stop reviewing.
