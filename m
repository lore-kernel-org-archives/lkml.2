Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683Ab1EZQGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:06:10 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62558 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab1EZQGG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:06:06 -0400
Subject: Re: [GIT PULL] omap updates for 2.6.40
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <20110526113905.GG27250@atomide.com>
Date: Thu, 26 May 2011 18:06:01 +0200
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <9741DC43-3197-4ECE-A377-FA865A3F6710@dominion.thruhere.net>
References: <20110526113905.GG27250@atomide.com>
To: Tony Lindgren <tony@atomide.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Op 26 mei 2011, om 13:39 heeft Tony Lindgren het volgende geschreven:

> Hi Linus,
> 
> Please pull omap updates for this merge window from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-for-linus
> 
> This contains clean-up to shrink down omap specific code a bit. Also included
> are some fixes. But basically no new code at this point.

What about updates to board files? Like adding support for the xM rev C to board-omap3beagle.c.