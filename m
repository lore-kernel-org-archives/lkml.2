Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760273Ab0HLPsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:48:20 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:51091 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab0HLPsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:48:18 -0400
Date: Thu, 12 Aug 2010 17:48:16 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCHv8 13/13] init.h: add some more documentation to __ref*
	tags
Message-ID: <20100812154816.GA31928@merkur.ravnborg.org>
References: <48e2d6507f004252a012cf25bc0a06e5cb69808f.1281625724.git.m.nazarewicz@samsung.com> <f2f6babb8b593d5c6f6141604bd647658d59f124.1281625724.git.m.nazarewicz@samsung.com> <4addd8199cfd6a2aa582904cd6efa01bc77a5290.1281625724.git.m.nazarewicz@samsung.com> <9737a711d395932c8803511ba581722d46be5292.1281625724.git.m.nazarewicz@samsung.com> <f07e8ff5f36d5893e62764b9e372da0cc305a2b5.1281625724.git.m.nazarewicz@samsung.com> <550ddf8273d87cb418dd5716cbec906e74aa03d4.1281625724.git.m.nazarewicz@samsung.com> <ad117de19af4733f113c8631e53556cc308dbf06.1281625724.git.m.nazarewicz@samsung.com> <340f780f91de1b3ca17d0c29d87963205d172f4e.1281625724.git.m.nazarewicz@samsung.com> <cfb1102e8bd59822b76475d58f5e4f1ceadade50.1281625724.git.m.nazarewicz@samsung.com> <596c51e49e129c14531a6367ea7b321ee541bdb5.1281625724.git.m.nazarewicz@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <596c51e49e129c14531a6367ea7b321ee541bdb5.1281625724.git.m.nazarewicz@samsung.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 05:43:56PM +0200, Michal Nazarewicz wrote:
> The __ref* tags may have been confusing for new kernel
> developers (I was confused by them for sure) so adding a few
> more sentences to comment to clear things up for people who
> see those for the first time.
> 
> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
