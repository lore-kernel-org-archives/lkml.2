Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab2KJSiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 13:38:19 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45188 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab2KJSiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 13:38:16 -0500
Date: Sat, 10 Nov 2012 13:38:10 -0500 (EST)
Message-Id: <20121110.133810.754496966938629729.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: krzysiek@podlesie.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, chas@cmf.nrl.navy.mil
Subject: Re: [PATCH v3 8/7] pppoatm: fix missing wakeup in pppoatm_send()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1352532973.9449.105.camel@shinybook.infradead.org>
References: <1352292734.7340.35.camel@shinybook.infradead.org>
	<20121109.163012.719663130136182296.davem@davemloft.net>
	<1352532973.9449.105.camel@shinybook.infradead.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Sat, 10 Nov 2012 07:36:13 +0000

> I was hoping for an ack from Chas and/or Krzysztof, especially as I
> hadn't tested my patch. So hopefully there'll be a v4 series of 8
> patches, including this one... and all from the same person, which
> makes it slightly easier to follow :)

Ok, great.
