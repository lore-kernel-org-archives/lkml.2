Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab1ERWPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 18:15:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37530 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab1ERWPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 18:15:48 -0400
Date: Wed, 18 May 2011 23:15:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ashish Jangam <Ashish.Jangam@kpitcummins.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <Dajun.Chen@diasemi.com>
Subject: Re: [PATCHv2 -next] LEDS: LED module of DA9052 PMIC driver
Message-ID: <20110518221542.GB20909@sirena.org.uk>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BC621FA@KCINPUNHJCMS01.kpit.com> <20110518122332.94d4fdb9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518122332.94d4fdb9.akpm@linux-foundation.org>
X-Cookie: Forgive and forget.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 12:23:32PM -0700, Andrew Morton wrote:

> A way to proceed with this patchset is to get the core PMIC_DA9052
> support patch merged and to then send the various dependent patches to
> the relevant maintainers.

...

> An alternative way of getting it all merged up is for us to ask Samuel
> to merge _all_ the patches, after receiving suitable acks and reviews
> from suitable people.  Or I can do that.

> I think the second way is better.  Sam?

The way these things have often been dealt with is to just merge the
code via the various trees and rely on -next for build testing - they
won't cause bisection issues as the lack of the MFD will prevent the
config being enabled, everything goes in in a single release and we
still get to keep all the code for each subsystem together.

Of course, since the code isn't even signed off we've got a way to go
yet...
