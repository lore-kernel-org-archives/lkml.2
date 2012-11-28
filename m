Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab2K1Ql6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:41:58 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50320 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab2K1Ql4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:41:56 -0500
Date: Wed, 28 Nov 2012 11:41:53 -0500 (EST)
Message-Id: <20121128.114153.737074131307295783.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: chas@cmf.nrl.navy.mil, krzysiek@podlesie.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, nathan@traverse.com.au
Subject: Re: [PATCH] br2684: don't send frames on not-ready vcc
From: David Miller <davem@davemloft.net>
In-Reply-To: <1354058916.2534.25.camel@shinybook.infradead.org>
References: <20121127135434.0728cd4f@thirdoffive.cmf.nrl.navy.mil>
	<1354055783.2534.18.camel@shinybook.infradead.org>
	<1354058916.2534.25.camel@shinybook.infradead.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Tue, 27 Nov 2012 23:28:36 +0000

> +	if (test_bit(ATM_VF_RELEASED, &atmvcc->flags)
> +	    || test_bit(ATM_VF_CLOSE, &atmvcc->flags)
> +	    || !test_bit(ATM_VF_READY, &atmvcc->flags)) {

Please:

	if (X ||
	    Y ||
	    Z)

not:

	if (X
	    || Y
	    || Z)

Thanks.
