Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab1CDWm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 17:42:28 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:34610 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932641Ab1CDWm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 17:42:27 -0500
Date: Fri, 4 Mar 2011 23:42:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org,
        security@kernel.org, Len Brown <len.brown@intel.com>,
        linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] power: disable hibernation if module loading is
 disabled
Message-ID: <20110304224225.GA23936@elf.ucw.cz>
References: <1299255084-4390-1-git-send-email-segoon@openwall.com>
 <201103042221.02852.rjw@sisk.pl>
 <20110304214630.GA29883@albatros>
 <201103042330.25079.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103042330.25079.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > If one may change kernel memory via swap then it is another problem with
> > modules_disabled.
> 
> If you want an interface to disable _any_ kind of writes into the kernel
> memory by any means, then please add it and don't call it modules_disabled,
> because it's a hell of a confusing name and no amount of documentation
> can help that.

...and that interface should be CAP_SYS_something, I'd say...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
