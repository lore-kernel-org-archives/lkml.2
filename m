Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226Ab1ADXKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 18:10:47 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39534 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab1ADXKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 18:10:46 -0500
Date: Tue, 4 Jan 2011 23:10:21 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Cc: Jean Delvare <khali@linux-fr.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-i2c@vger.kernel.org, Rabin Vincent <rabin@rab.in>,
        Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH] i2c: Factor out runtime suspend checks from PM
	operations
Message-ID: <20110104231021.GA18024@sirena.org.uk>
References: <1293712813-4090-1-git-send-email-broonie@opensource.wolfsonmicro.com> <4D23A839.6030205@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D23A839.6030205@codeaurora.org>
X-Cookie: Logic is the chastity belt of the mind!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 03:07:37PM -0800, Abhijeet Dharmapurikar wrote:
> Mark Brown wrote:

>> device op. The PM core provides pm_generic_ functions implementing this
>> behaviour - use them to reduce coupling with future PM updates.

> pm_generic_suspend() and others needs to be externed in linux/pm_runtime.h?

Yes, there's a patch in -next for this already so this patch would need
to either wait for later in the merge window or go in via the PM tree
with the preceeding one (the original version of this patch was posted
as part of a series with the export patch).
