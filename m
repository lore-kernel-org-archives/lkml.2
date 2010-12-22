Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab0LVPZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 10:25:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52901 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753598Ab0LVPZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 10:25:52 -0500
Date: Wed, 22 Dec 2010 15:25:51 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rabin Vincent <rabin@rab.in>
Cc: Ben Dooks <ben-linux@fluff.org>, Jean Delvare <khali@linux-fr.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org,
        patches@opensource.wolfsonmicro.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH 2/2] i2c: Factor out runtime suspend checks
	from PM operations
Message-ID: <20101222152550.GA16099@opensource.wolfsonmicro.com>
References: <1292855593-30608-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1292855593-30608-2-git-send-email-broonie@opensource.wolfsonmicro.com> <AANLkTi=KOq65TS299rB=K961=mVXnriyqNxdHzJey5rD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=KOq65TS299rB=K961=mVXnriyqNxdHzJey5rD@mail.gmail.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 08:40:23PM +0530, Rabin Vincent wrote:

> Shouldn't you be deleting the pm_runtime_* stuff from here?  There is
> already done in pm_generic_restore() iff the callback exists and returns
> zero.

I guess; it's not clear why this is being done by the bus at all or how
it interacts with the legacy stuff.
