Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab0C3JsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 05:48:16 -0400
Received: from mx51.mymxserver.com ([85.199.173.110]:7548 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab0C3JsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 05:48:14 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Daniel Mack <daniel@caiaq.de>
Subject: Re: [PATCH] net/wireless/libertas: do not call wiphy_unregister() w/o wiphy_register()
Date: Tue, 30 Mar 2010 11:49:13 +0200
User-Agent: KMail/1.13.1 (Linux/2.6.33; KDE/4.4.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Bing Zhao <bzhao@marvell.com>, libertas-dev@lists.infradead.org,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <1269875658-3324-1-git-send-email-daniel@caiaq.de> <201003300849.07441.hs4233@mail.mn-solutions.de> <20100330085253.GL30801@buzzloop.caiaq.de>
In-Reply-To: <20100330085253.GL30801@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003301149.13462.hs4233@mail.mn-solutions.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If there's any better solution, I'd happily test it.

Not from me, unfortunately. I'm not really interested into getting full 
cfg80211 into Libertas. That is, until either _one_ of this two options 
happen:

* someone that actually uses/wants the proprietary Libertas mesh steps  
forward and says "We'll look after this and make it work with cfg80211"
* we remove the proprietary Libertas mesh support

That is: I won't work on Libertas mesh. I can't justify this time investment 
with my employer for something that I'll never need. For my device, my own 
version of Libertas + cfg80211 (without any WEXT anymore) works quite nice.


So, if neither of the above things happens, then Libertas will work for the 
rest of the world with WEXT, as it did before.
