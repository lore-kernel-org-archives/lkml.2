Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab2D3WdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 18:33:24 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51986 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627Ab2D3WdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 18:33:23 -0400
Date: Mon, 30 Apr 2012 23:33:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-serial@vger.kernel.org, linux-pm@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Question:  How to power-manage UART-attached devices.
Message-ID: <20120430223322.GA3951@sirena.org.uk>
References: <20120501082209.0b560708@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120501082209.0b560708@notabene.brown>
X-Cookie: Serenity through viciousness.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 08:22:09AM +1000, NeilBrown wrote:

>  The question is how can user-space tell the kernel that these devices are
>  'inactive'?

>  I would like to integrate this into Linux in the most  "natural" way that I
>  can but am having trouble.  My current approach involves using "rfkill" but
>  that doesn't work very well for reasons that are probably not very relevant
>  here.  It probably does make sense for powering the GPS antenna, but not
>  much else.

The userspace consumer was added for users like this that live entirely
in userspace.
