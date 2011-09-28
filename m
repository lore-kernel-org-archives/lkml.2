Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab1I1HYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:24:24 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:55790 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab1I1HYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:24:23 -0400
Date: Wed, 28 Sep 2011 03:24:19 -0400 (EDT)
Message-Id: <20110928.032419.2113734655470772752.davem@davemloft.net>
To: jgq516@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net/fec: replace hardcoded irq num with macro.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1316830784-17108-1-git-send-email-jgq516@gmail.com>
References: <1316830784-17108-1-git-send-email-jgq516@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 28 Sep 2011 00:24:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please respin these patches against net-next, where the FEC driver
lives in a different directory.

Thanks.
