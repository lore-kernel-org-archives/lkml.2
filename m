Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab1E0FNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 01:13:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55777 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750804Ab1E0FNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 01:13:12 -0400
Date: Fri, 27 May 2011 06:01:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Kyungmin Park <kmpark@infradead.org>, linux-kernel@vger.kernel.org,
        arnd@arndb.de, kgene.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] Samsung: Move Samsung SoCs GPIO drivers to
	drivers/gpio
Message-ID: <20110527050138.GA23418@opensource.wolfsonmicro.com>
References: <20110520054441.GA9952@july> <20110520063128.GA21285@ponder.secretlab.ca> <20110521112102.GA11887@sirena.org.uk> <20110527032243.GJ5032@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110527032243.GJ5032@ponder.secretlab.ca>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 09:22:43PM -0600, Grant Likely wrote:

> True, this does come down to personal taste, but unless someone has a
> really strong objection to it then I'll keep asking for new drivers to
> use gpio- as a prefix.

Right, my thought was more that if that's going to be the way forward
it's probably worth renaming the existing drivers so people don't get
confused - people are likely to pick the visible convention as their
first thought so we should either standardise on the existing one or
change what's there.  It's nicer if what you're supposed to do is what
everyone's actually doing :)
