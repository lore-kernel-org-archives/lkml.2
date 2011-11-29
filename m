Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab1K2GV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 01:21:26 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:34945 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab1K2GVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 01:21:24 -0500
Date: Tue, 29 Nov 2011 01:17:17 -0500 (EST)
Message-Id: <20111129.011717.1510779658553334799.davem@davemloft.net>
To: axel.lin@gmail.com
Cc: linux-kernel@vger.kernel.org, pantelis.antoniou@gmail.com,
        vbordug@ru.mvista.com, mcuos.com@gmail.com, nico@fluxnic.net,
        peppe.cavallaro@st.com, mkl@pengutronix.de,
        jeffrey.t.kirsher@intel.com, jpirko@redhat.com, daniel@gaisler.com,
        adobriyan@gmail.com, tklauser@distanz.ch, grant.likely@secretlab.ca,
        jkosina@suse.cz, richard.cochran@omicron.at, jonas@southpole.se,
        sebastian.poehn@belden.com, yoshihiro.shimoda.uh@renesas.com,
        ricardo.ribalda@gmail.com, mirq-linux@rere.qmqm.pl,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net/ethernet: convert drivers/net/ethernet/* to use
 module_platform_driver()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1322448257.2408.6.camel@phoenix>
References: <1322448257.2408.6.camel@phoenix>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 28 Nov 2011 22:17:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 28 Nov 2011 10:44:17 +0800

> This patch converts the drivers in drivers/net/ethernet/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied.
