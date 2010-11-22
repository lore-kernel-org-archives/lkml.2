Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723Ab0KVWkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 17:40:10 -0500
Received: from mail.perches.com ([173.55.12.10]:1796 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757289Ab0KVWkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 17:40:07 -0500
Subject: Re: [PATCH 00/62] drivers/net: Use static const
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath5k-devel@venema.h4ckr.net, ath9k-devel@venema.h4ckr.net,
        libertas-dev@lists.infradead.org, users@rt2x00.serialmonkey.com,
        linux-kernel@vger.kernel.org, socketcan-core@lists.berlios.de
In-Reply-To: <20101122.141939.226774888.davem@davemloft.net>
References: <cover.1290305773.git.joe@perches.com>
	 <20101120.205059.193725921.davem@davemloft.net>
	 <1290463846.27683.36.camel@Joe-Laptop>
	 <20101122.141939.226774888.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 14:40:05 -0800
Message-ID: <1290465605.27683.52.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 14:19 -0800, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Mon, 22 Nov 2010 14:10:46 -0800
> > Do let me know if you'd consider pulling these sorts of
> > changes from me.
> Expand your horizon beyond drivers/net/ and into places like net/
> and you'll see I also pull from people like Patrick McHardy, for
> example.

I'll see who picks up or acks what and send a pull request to
you for the remainder of these patches mid December or so.

Do you want micro patches or a single patch?

