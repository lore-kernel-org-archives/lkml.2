Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab2FGUjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:39:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45564 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab2FGUjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:39:01 -0400
Date: Thu, 07 Jun 2012 13:39:00 -0700 (PDT)
Message-Id: <20120607.133900.1764130639940088009.davem@davemloft.net>
To: cmetcalf@tilera.com
Cc: eric.dumazet@gmail.com, bhutchings@solarflare.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v10] tilegx network driver: initial support
From: David Miller <davem@davemloft.net>
In-Reply-To: <201206072031.q57KV0NG029301@farm-0023.internal.tilera.com>
References: <4FCFA312.4020505@tilera.com>
	<20120606.115440.1245419453265419850.davem@davemloft.net>
	<201206072031.q57KV0NG029301@farm-0023.internal.tilera.com>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 6 Apr 2012 16:42:03 -0400

> Date: Fri, 6 Apr 2012 16:42:03 -0400

You did not commit this file on April 6th.

Please don't use the date emitted by the GIT tools, just
let the email use the natural correct date which is the
one at the time you send the email out.

Otherwise your patch gets misordered as automated tools like
patchwork think this file should go all the way at the back
of the patch queue because of it's old date relative to
other pending patches.
