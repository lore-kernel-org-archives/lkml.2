Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab1KQDTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 22:19:21 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51547 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab1KQDTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 22:19:18 -0500
Message-ID: <1321499952.3274.11.camel@edumazet-laptop>
Subject: Re: [PATCH net-next v6 3/9] kbuild: document RPS/XPS network
 Kconfig options
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: bhutchings@solarflare.com, david.decotigny@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ian.campbell@citrix.com, jeffrey.t.kirsher@intel.com,
        jpirko@redhat.com, joe@perches.com, szymon@janc.net.pl,
        rick.jones2@hp.com, AAbdulla@nvidia.com, therbert@google.com
Date: Thu, 17 Nov 2011 04:19:12 +0100
In-Reply-To: <20111116.215901.100218898762260021.davem@davemloft.net>
References: <1321485122.2709.55.camel@bwh-desktop>
	 <CAG88wWZ853cHkykNbQ+Lqrk_D1p-SCmB0Y29YE6GpSSUORwCxg@mail.gmail.com>
	 <1321498443.2885.80.camel@deadeye>
	 <20111116.215901.100218898762260021.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 16 novembre 2011 à 21:59 -0500, David Miller a écrit :

> They shouldn't be, they are internal dependency descriptions and should
> be invisible to the user.

Unless someone has evidence of a performance cost :)

The rps_lock() adds an atomic operation in netif_rx(), even if RPS is
not really used/configured...



