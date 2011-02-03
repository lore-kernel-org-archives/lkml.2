Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab1BCMph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 07:45:37 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43470 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab1BCMpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 07:45:33 -0500
Date: Thu, 3 Feb 2011 12:45:21 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arve Hj??nnev??g <arve@android.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Alexander Shishkin <virtuoso@slind.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 1/5] ARM: etm: Don't require clock control
Message-ID: <20110203124521.GK9810@sirena.org.uk>
References: <1296701663-12168-1-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296701663-12168-1-git-send-email-arve@android.com>
X-Cookie: 1 bulls, 3 cows.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 06:54:19PM -0800, Arve Hj??nnev??g wrote:
> If clk_get fail, assume the etb does not need a separate clock.
> 
> Signed-off-by: Arve Hj??nnev??g <arve@android.com>

Would it not be cleaner for the affected platforms to ensure that
clk_get() does the right thing here, for example by returning a dummy
clock?  Otherwise we'll just silently carry on if we can't get a clock
we were supposed to which doesn't seem ideal.
