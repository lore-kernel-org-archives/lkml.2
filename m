Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab2FTEhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 00:37:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33643 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab2FTEhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 00:37:04 -0400
Date: Tue, 19 Jun 2012 21:37:03 -0700 (PDT)
Message-Id: <20120619.213703.513466167861199217.davem@davemloft.net>
To: bhupesh.sharma@st.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, federico.vaga@gmail.com,
        giancarlo.asnaghi@st.com, wg@grandegger.com, mkl@pengutronix.de
Subject: Re: linux-next: build failure after merge of the net-next tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384FAA275CA8@EAPEX1MAIL1.st.com>
References: <20120620133348.a9ff31a72ffd11818f574fe3@canb.auug.org.au>
	<D5ECB3C7A6F99444980976A8C6D896384FAA275CA8@EAPEX1MAIL1.st.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bhupesh SHARMA <bhupesh.sharma@st.com>
Date: Wed, 20 Jun 2012 12:27:11 +0800

> clk_get/clk_put* variants are usually used by ARM platforms.
> Protecting their calls under macro 'CONFIG_HAVE_CLK' should solve the problem.

No, we don't pepper foo.c files with crappy ifdefs.
