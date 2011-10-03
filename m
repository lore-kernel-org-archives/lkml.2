Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab1JCJQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:16:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60943 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab1JCJQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:16:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Archit Taneja <archit@ti.com>
Cc: Tony Lindgren <tony@atomide.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "JAIN, AMBER" <amber@ti.com>, "Hiremath, Vaibhav" <hvaibhav@ti.com>
Subject: Re: [PATCH 20/30] media/omap_vout: disable driver for now
Date: Mon, 03 Oct 2011 11:16:26 +0200
Message-ID: <1742744.loikWKTXp9@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <4E8951B7.7010106@ti.com>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <1317566760-25681-21-git-send-email-arnd@arndb.de> <4E8951B7.7010106@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:pBWiyun4RTrRm/tAfZO3Ad0SOGjHdC+re6KLtP9XZdx
 dbv3dHnPdDq8x3LgqPs/ocWvxXNaIuH1TL3uRqkEx47MwnJnpw
 7BkrDj1U1GAFBZyuRA0jZMKbfiIBS6VKIXSvd4GsWsuz5CXTWi
 DXnZP1gp5FSZV5VZdMB67oRN4t+/BUCo90FyPRDmon24AgB5Y+
 g8LfwX89yTynIkZOI/pWqnB7J5Uy+A5nCQW4oAH1vJiJ5K44lg
 xpRqh/1IUS/H/V7vVSTpo2SawGAjqa4BwqRugPIX+aNiAyiaE4
 1y/Mdci5mTg3a1p6ikWTw/wUrPKQ6s7wpqV13XuLlN1hD57pV3
 AMOqW0WgyX2gLOzF+HfA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 October 2011 11:39:59 Archit Taneja wrote:
> 
> A fix for this is already in the master branch of Mauro's tree:
> 
> git://linuxtv.org/media_tree.git
> 
> with the commit id:
> 
> 5ebbf72dc51bd3b481aa91fea37a7157da5fc548
> 
> I am guessing this would during the 3.2 merge window.

Ok, thanks for the info! We can drop this then.

	Arnd
