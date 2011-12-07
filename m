Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734Ab1LGSiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 13:38:18 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:46468 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab1LGSiQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 13:38:16 -0500
Date: Wed, 07 Dec 2011 13:38:00 -0500 (EST)
Message-Id: <20111207.133800.1403774147364781100.davem@davemloft.net>
To: LW@KARO-electronics.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, shawn.guo@linaro.org
Subject: Re: [PATCH v2 0/8][NET] fec.c: several cleanups and bugfixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1323256319.git.LW@KARO-electronics.de>
References: <cover.1323256319.git.LW@KARO-electronics.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 07 Dec 2011 10:38:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lothar Waﬂmann <LW@KARO-electronics.de>
Date: Wed,  7 Dec 2011 14:37:12 +0100

> The following set of patches provides some cleanup and bugfixes for
> drivers/net/ethernet/freescale/fec.c and makes the driver buildable as
> a module.

1) I said to use a subject prefix of "fec: " not "fec.c: "

2) You did not integrate Shawn's "Acked-by: " tags, I'm not going to
   go sifting through the previous patch postings to collect them up,
   that's your job.
