Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab2BQT1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 14:27:33 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60535 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab2BQT1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 14:27:30 -0500
Date: Fri, 17 Feb 2012 20:27:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jean Pihet <jean.pihet@newoldbits.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Jean Pihet <j-pihet@ti.com>, linux-kernel@vger.kernel.org,
        Mark Gross <markgross@thegnar.org>
Subject: Re: [linux-pm] [PATCH] PM / QoS: unconditionally build the feature
Message-ID: <20120217192724.GC2707@elf.ucw.cz>
References: <1328603646-2714-2-git-send-email-j-pihet@ti.com>
 <1329141059-16554-1-git-send-email-j-pihet@ti.com>
 <201202131641.10535.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201202131641.10535.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2012-02-13 16:41:10, Rafael J. Wysocki wrote:
> On Monday, February 13, 2012, Jean Pihet wrote:
> > The PM QoS feature depends on CONFIG_PM which depends on
> > PM_SLEEP || PM_RUNTIME. This breaks CPU C-states with kernels
> > not having these CONFIGs.
> > 
> > This patch allows the feature in all cases.
> > 
> > Signed-off-by: Jean Pihet <j-pihet@ti.com>
> > Reported-by: Venkatesh Pallipadi <venki@google.com>
> > Cc: Rafael J. Wysocki <rjw@sisk.pl>
> > Cc: Mark Gross <markgross@thegnar.org>
> 
> Applied, but I modified the changelog (please have a look at the
> linux-pm/pm-qos branch for details).

Is it good idea? For servers, power management / QoS is not
neccessary... What about fixing kconfig, instead?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
