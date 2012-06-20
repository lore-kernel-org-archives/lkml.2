Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab2FTEsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 00:48:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33730 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab2FTEsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 00:48:00 -0400
Date: Tue, 19 Jun 2012 21:47:59 -0700 (PDT)
Message-Id: <20120619.214759.2265041580160751452.davem@davemloft.net>
To: bhupesh.sharma@st.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, federico.vaga@gmail.com,
        giancarlo.asnaghi@st.com, wg@grandegger.com, mkl@pengutronix.de
Subject: Re: linux-next: build failure after merge of the net-next tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384FAA275CBE@EAPEX1MAIL1.st.com>
References: <D5ECB3C7A6F99444980976A8C6D896384FAA275CA8@EAPEX1MAIL1.st.com>
	<20120619.213703.513466167861199217.davem@davemloft.net>
	<D5ECB3C7A6F99444980976A8C6D896384FAA275CBE@EAPEX1MAIL1.st.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bhupesh SHARMA <bhupesh.sharma@st.com>
Date: Wed, 20 Jun 2012 12:45:46 +0800

> So, whether adding a check in Kconfig for HAVE_CLK be a proper
> solution ?  But that will limit the compilation of this driver for
> only platforms which are ARM based.
> 
> One may need to support this driver on x86 like platforms also..

Then x86 will need to provide clock operations, or there needs to
be dummy ones for such platforms.

This isn't rocket science.
