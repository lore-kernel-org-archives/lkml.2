Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab2FTI7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:59:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49059 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab2FTI7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:59:40 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Bhupesh SHARMA <bhupesh.sharma@st.com>, David Miller <davem@davemloft.net>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Giancarlo ASNAGHI <giancarlo.asnaghi@st.com>,
        "wg@grandegger.com" <wg@grandegger.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
Date: Wed, 20 Jun 2012 11:03:08 +0200
Message-ID: <3170667.1PZa2330KE@harkonnen>
User-Agent: KMail/4.8.3 (Linux/3.4.2-4.fc17.x86_64; KDE/4.8.3; x86_64; ; )
In-Reply-To: <4FE18A5E.204@pengutronix.de>
References: <20120620133348.a9ff31a72ffd11818f574fe3@canb.auug.org.au> <D5ECB3C7A6F99444980976A8C6D896384FAA275CBE@EAPEX1MAIL1.st.com> <4FE18A5E.204@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think the driver is currently used/tested only on ARM only, so what
> about adding a HAVE_CLK dependency, until Viresh Kumar's patches are
> available in net-next. Later we can remove it.

This driver is tested only on an x86 with AMBA peripherals on PCI. We 
are developing the clk side for this new platform. 

-- 
Federico Vaga
