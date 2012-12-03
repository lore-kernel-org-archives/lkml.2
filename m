Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab2LCTtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 14:49:03 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40031 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab2LCTtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 14:49:01 -0500
Date: Mon, 03 Dec 2012 14:48:59 -0500 (EST)
Message-Id: <20121203.144859.1267538781200082757.davem@davemloft.net>
To: mst@redhat.com
Cc: jasowang@redhat.com, nhorman@tuxdriver.com, ramirose@gmail.com,
        davej@redhat.com, mtk.manpages@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] tun: only queue packets on device
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121203194850.GA920@redhat.com>
References: <20121203194850.GA920@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Mon, 3 Dec 2012 21:48:50 +0200

>  
> +	/* This flag has no real effect.  We track the value for backwards
> +	 * compatibility. */

	/* Always
	 * like this.
	 */

	/*
	 * Never
	 * like this.
	 */

	 /* And never
	  * like this.  */
