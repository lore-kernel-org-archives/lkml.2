Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab2GWGfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 02:35:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42069 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab2GWGfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 02:35:07 -0400
Date: Sun, 22 Jul 2012 23:35:06 -0700 (PDT)
Message-Id: <20120722.233506.850170096735613796.davem@davemloft.net>
To: shuah.khan@hp.com
Cc: mcarlson@broadcom.com, bhutchings@solarflare.com, eric.dumazet@gmail.com,
        mchan@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH RFT] net: Change niu_rbr_fill() to use unlikely() to
 check niu_rbr_add_page() return value
From: David Miller <davem@davemloft.net>
In-Reply-To: <1342827272.5434.71.camel@lorien2>
References: <1342827272.5434.71.camel@lorien2>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shuah Khan <shuah.khan@hp.com>
Date: Fri, 20 Jul 2012 17:34:32 -0600

> Change niu_rbr_fill() to use unlikely() to check niu_rbr_add_page() return
> value to be consistent with the rest of the checks after niu_rbr_add_page()
> calls in this file.
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>

Applied.
