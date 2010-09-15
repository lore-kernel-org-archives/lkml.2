Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab0IOJkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 05:40:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43220 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab0IOJkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 05:40:12 -0400
Date: Wed, 15 Sep 2010 10:40:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Chris Ball <cjb@laptop.org>
Cc: Saeed Bishara <saeed@marvell.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: Add architecture dependency for Marvell SoC
	controller
Message-ID: <20100915094006.GA21620@sirena.org.uk>
References: <1284366279-17140-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20100914190549.GA21918@void.printf.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100914190549.GA21918@void.printf.net>
X-Cookie: A company is known by the men it keeps.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 08:05:49PM +0100, Chris Ball wrote:

> This is fine with me.  Saeed, please can you ACK the choice of
> platforms if you agree?

If the list of platforms is wrong we should probably also improve the
help text :)
