Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab2LQNsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 08:48:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806Ab2LQNsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 08:48:50 -0500
Date: Mon, 17 Dec 2012 14:48:30 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [3.7.0 regression] rt2x00lib_probe_dev: Error - Failed to
 initialize hw
Message-ID: <20121217134829.GA25021@redhat.com>
References: <20686.63778.840426.61474@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20686.63778.840426.61474@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 11:51:14AM +0100, Mikael Pettersson wrote:
> I just updated an old 1st gen AMD64 laptop from kernel 3.6.0 to 3.7.0,
> Fedora 15 user-space, and was greeted by the following kernel warning:
> 
> WARNING: at net/wireless/core.c:389 wiphy_register+0x5c3/0x600 [cfg80211]()

Already fixed on linus tree, should appear in 3.7 -stable soon.

commit f5685ba675449b072feab6a5391a9ef9f604bc94
Author: Helmut Schaa <helmut.schaa@googlemail.com>
Date:   Mon Dec 3 22:35:39 2012 +0100

    rt2x00: Only specify interface combinations if more then one interface is possible

Stanislaw
