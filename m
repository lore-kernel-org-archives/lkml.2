Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab2GWGfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 02:35:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42063 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab2GWGfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 02:35:03 -0400
Date: Sun, 22 Jul 2012 23:34:57 -0700 (PDT)
Message-Id: <20120722.233457.2263398598927809265.davem@davemloft.net>
To: shuah.khan@hp.com
Cc: mcarlson@broadcom.com, bhutchings@solarflare.com, eric.dumazet@gmail.com,
        mchan@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH RFT RESEND] net: Fix Neptune ethernet driver to check
 dma mapping error
From: David Miller <davem@davemloft.net>
In-Reply-To: <1342821035.5434.60.camel@lorien2>
References: <1342821035.5434.60.camel@lorien2>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shuah Khan <shuah.khan@hp.com>
Date: Fri, 20 Jul 2012 15:50:35 -0600

> Fix Neptune ethernet driver to check dma mapping error after map_page()
> interface returns.
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>

Applied.
