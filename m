Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab1KQDNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 22:13:10 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:51503 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab1KQDNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 22:13:09 -0500
Date: Wed, 16 Nov 2011 22:12:41 -0500 (EST)
Message-Id: <20111116.221241.584246208264764477.davem@davemloft.net>
To: david.decotigny@google.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ian.campbell@citrix.com, eric.dumazet@gmail.com,
        jeffrey.t.kirsher@intel.com, bhutchings@solarflare.com,
        jpirko@redhat.com, joe@perches.com, szymon@janc.net.pl,
        rick.jones2@hp.com, AAbdulla@nvidia.com
Subject: Re: [PATCH net-next v6 3/9] kbuild: document RPS/XPS network
 Kconfig options
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAG88wWYgUkStZk988iWzbWf_=1Ze-Rtvs82sMrZoeuFPQphaUA@mail.gmail.com>
References: <e0bb736123d687a921f15e4bb0254eeeabe22dcb.1321496595.git.david.decotigny@google.com>
	<20111116.215808.299077226767455988.davem@davemloft.net>
	<CAG88wWYgUkStZk988iWzbWf_=1Ze-Rtvs82sMrZoeuFPQphaUA@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 16 Nov 2011 19:12:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <david.decotigny@google.com>
Date: Wed, 16 Nov 2011 19:04:58 -0800

> David, should I re-send an updated v7 version of this series with this
> patch removed? Or is it Ok if I simply mark this patch as rejected in
> patchwork and stick to patch series v6?

I'll try to apply v6 as-is sans patch #3.
