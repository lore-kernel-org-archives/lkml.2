Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684Ab1DMQxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:53:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34568 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757215Ab1DMQxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:53:30 -0400
Date: Wed, 13 Apr 2011 09:53:38 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Antonio Ospite <ospite@studenti.unina.it>, linux-wireless@vger.kernel.org,
        openezx-devel@lists.openezx.org,
        "John W . Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Guiming Zhuo <gmzhuo@gmail.com>
Subject: Re: [PATCH v2] rfkill: Regulator consumer driver for rfkill
Message-ID: <20110413165337.GA18008@opensource.wolfsonmicro.com>
References: <1302082178.3811.7.camel@jlt3.sipsolutions.net>
 <1302260395-11872-1-git-send-email-ospite@studenti.unina.it>
 <1302608488.3639.15.camel@jlt3.sipsolutions.net>
 <1302608642.3639.17.camel@jlt3.sipsolutions.net>
 <20110412151554.GA20710@opensource.wolfsonmicro.com>
 <1302621781.3639.18.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302621781.3639.18.camel@jlt3.sipsolutions.net>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 05:23:01PM +0200, Johannes Berg wrote:
> On Tue, 2011-04-12 at 08:15 -0700, Mark Brown wrote:

> > No, if you're passing supply names through platform data something has
> > gone wrong - that's a big no no.

> Ok. The comment seems a little wrong still though, maybe leftover bits
> from an older version?

Dunno but it's definitely buggy.

