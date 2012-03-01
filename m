Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab2CAU5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:57:49 -0500
Received: from antcom.de ([188.40.178.216]:40688 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757751Ab2CAU5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:57:48 -0500
Message-ID: <4F4FDF2D.5040508@antcom.de>
Date: Thu, 01 Mar 2012 21:42:21 +0100
From: Roland Stigge <stigge@antcom.de>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: davem@davemloft.net, jeffrey.t.kirsher@intel.com,
        alexander.h.duyck@intel.com, eilong@broadcom.com,
        ian.campbell@citrix.com, netdev@vger.kernel.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org, baruch@tkos.co.il,
        joe@perches.com
Subject: Re: [PATCH v3] lpc32xx: Added ethernet driver
References: <1330364539-23152-1-git-send-email-stigge@antcom.de> <201202271949.03144.arnd@arndb.de>
In-Reply-To: <201202271949.03144.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/02/12 20:49, Arnd Bergmann wrote:
> Are you sure that npx is actually the origin of this controller?
> If they only licensed the IP themselves, it would be better to list
> it under the name of the actual creator so that the next person
> who has the same core can find it.

I have no hint for another origin of this core (see manual). However, as
soon as we get new info on this, we can move the driver easily.

Thanks to all of you for your suggestions, I will include all the
suggested changes an repost an updated driver.

Roland
