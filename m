Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab2FTIlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:41:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35520 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab2FTIld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:41:33 -0400
Date: Wed, 20 Jun 2012 01:41:32 -0700 (PDT)
Message-Id: <20120620.014132.2222580541940208799.davem@davemloft.net>
To: mkl@pengutronix.de
Cc: bhupesh.sharma@st.com, sfr@canb.auug.org.au, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        federico.vaga@gmail.com, giancarlo.asnaghi@st.com, wg@grandegger.com
Subject: Re: linux-next: build failure after merge of the net-next tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FE18A5E.204@pengutronix.de>
References: <20120619.213703.513466167861199217.davem@davemloft.net>
	<D5ECB3C7A6F99444980976A8C6D896384FAA275CBE@EAPEX1MAIL1.st.com>
	<4FE18A5E.204@pengutronix.de>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Wed, 20 Jun 2012 10:31:26 +0200

> I think the driver is currently used/tested only on ARM only, so what
> about adding a HAVE_CLK dependency, until Viresh Kumar's patches are
> available in net-next. Later we can remove it.

Sounds good.
