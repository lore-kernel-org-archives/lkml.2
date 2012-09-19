Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871Ab2ISRuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:50:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55720 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932789Ab2ISRuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:50:08 -0400
Date: Wed, 19 Sep 2012 13:50:06 -0400 (EDT)
Message-Id: <20120919.135006.394934820049386022.davem@davemloft.net>
To: nicolas.ferre@atmel.com
Cc: netdev@vger.kernel.org, havard@skinnemoen.net, bhutchings@solarflare.com,
        linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com,
        patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] net/macb: driver enhancement concerning GEM
 support, ring logic and cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1348055112.git.nicolas.ferre@atmel.com>
References: <cover.1348055112.git.nicolas.ferre@atmel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Wed, 19 Sep 2012 13:55:13 +0200

> This is an enhancement work that began several years ago. I try to catchup with
> some performance improvement that has been implemented then by Havard.
> The ring index logic and the TX error path modification are the biggest changes
> but some cleanup/debugging have been added along the way.
> The GEM revision will benefit from the Gigabit support.
> 
> The series has been tested on several Atmel AT91 SoC with the two MACB/GEM
> flavors.
> 
> v2: - modify the tx error handling: now uses a workqueue
>     - information provided by ethtool -i were not accurate: removed

Don't submit patches like this.

When you put an RFC right in the middle of the series, it screws everything
up.

It means that I can't only apply the parts that are not RFC.
