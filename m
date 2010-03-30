Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab0C3GsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 02:48:09 -0400
Received: from mx51.mymxserver.com ([85.199.173.110]:15667 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab0C3GsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 02:48:07 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Daniel Mack <daniel@caiaq.de>
Subject: Re: [PATCH] net/wireless/libertas: do not call wiphy_unregister() w/o wiphy_register()
Date: Tue, 30 Mar 2010 08:49:07 +0200
User-Agent: KMail/1.13.1 (Linux/2.6.33; KDE/4.4.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Bing Zhao <bzhao@marvell.com>, libertas-dev@lists.infradead.org,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <1269875658-3324-1-git-send-email-daniel@caiaq.de>
In-Reply-To: <1269875658-3324-1-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201003300849.07441.hs4233@mail.mn-solutions.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The libertas driver calls wiphy_unregister() without a prior
> wiphy_register() when a devices fails initialization. Fix this by
> introducing a private flag.

Nice.

However, I wonder: do we really need a private variable?  Does each driver 
introduce a private variable for this?
