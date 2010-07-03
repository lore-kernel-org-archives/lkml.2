Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab0GCQs1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 12:48:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56528
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751909Ab0GCQs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 12:48:26 -0400
Date: Sat, 03 Jul 2010 09:48:39 -0700 (PDT)
Message-Id: <20100703.094839.189697623.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] ide: stop using q->prepare_flush_fn
From: David Miller <davem@davemloft.net>
In-Reply-To: <1278146740-8731-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1278146740-8731-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1278146740-8731-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Sat,  3 Jul 2010 17:45:39 +0900

> use REQ_FLUSH flag instead.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: David S. Miller <davem@davemloft.net>
