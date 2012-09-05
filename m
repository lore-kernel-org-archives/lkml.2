Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570Ab2IEVcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:32:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44879 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759468Ab2IEVcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:32:10 -0400
Date: Wed, 05 Sep 2012 17:32:08 -0400 (EDT)
Message-Id: <20120905.173208.1472160105562166368.davem@davemloft.net>
To: nicolas.ferre@atmel.com
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        havard@skinnemoen.net, plagnioj@jcrosoft.com, jamie@jamieiles.com,
        linux-kernel@vger.kernel.org, patrice.vilchez@atmel.com
Subject: Re: [PATCH 09/10] net/macb: ethtool interface: add register dump
 feature
From: David Miller <davem@davemloft.net>
In-Reply-To: <fcd1c2443a30f23ffcd8de28328c5a382e2a2459.1346775479.git.nicolas.ferre@atmel.com>
References: <cover.1346775479.git.nicolas.ferre@atmel.com>
	<fcd1c2443a30f23ffcd8de28328c5a382e2a2459.1346775479.git.nicolas.ferre@atmel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Wed, 5 Sep 2012 11:00:54 +0200

> @@ -10,6 +10,9 @@
>  #ifndef _MACB_H
>  #define _MACB_H
>  
> +
> +#define MACB_GREGS_LEN 32

Please don't add such extraneous empty lines.  One empty line between
constructs is more than enough, and anything more is visually awkward.

Thanks.


