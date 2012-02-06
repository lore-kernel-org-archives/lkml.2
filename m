Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab2BFQ5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:57:00 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37455 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab2BFQ47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:56:59 -0500
Date: Mon, 6 Feb 2012 17:56:58 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Cc: linux-pm@lists.linux-foundation.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, rob.lee@linaro.org,
        Greg KH <greg@kroah.com>
Subject: Re: [linux-pm] [RFC PATCH] thermal: Add support to report cooling
 statistics achieved by cooling devices
Message-ID: <20120206165658.GA28687@atrey.karlin.mff.cuni.cz>
References: <1326878467-17766-1-git-send-email-amit.kachhap@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326878467-17766-1-git-send-email-amit.kachhap@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Add a sysfs node code to report effective cooling of all cooling devices
> attached to each trip points of a thermal zone. The cooling data reported
> will be absolute if the higher temperature trip points are arranged first
> otherwise the cooling stats is the cumulative effect of the earlier
> invoked cooling handlers.
> 
> The basic assumption is that cooling devices will bring down the temperature
> in a symmetric manner and those statistics can be stored back and used for
> further tuning of the system.

/sys fs should be one-value-per-file, talk to gregkh.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
