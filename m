Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab1DFAGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 20:06:24 -0400
Received: from imr4.ericy.com ([198.24.6.8]:47094 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab1DFAGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 20:06:21 -0400
Date: Tue, 5 Apr 2011 17:05:28 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Natarajan Gurumoorthy <natg@google.com>
CC: Jean Delvare <khali@linux-fr.org>, Wim Van Sebroeck <wim@iguana.be>,
        Mike Waychison <mikew@google.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH] Make all it87 drivers SMP safe.
Message-ID: <20110406000528.GB21350@ericsson.com>
References: <1302038697-28985-1-git-send-email-natg@google.com>
 <20110405223814.GA21350@ericsson.com>
 <BANLkTimQDVYe53K-M173iQtmkHzKg6Djyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BANLkTimQDVYe53K-M173iQtmkHzKg6Djyg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 07:03:35PM -0400, Natarajan Gurumoorthy wrote:
> Guenter,
>        This patch patch applies a common fix to all IT87 driver. Separating it
> into 2 patches (one for drivers/hwmon and one for drivers/watchdog) does not
> seem to be the right thing to do. I think having all the patches in one file
> makes it easier to understand the rationale behind the patch. The
> it87_io_lock.c and it87_io_lock.h files are in drivers/watchdog directory and
> the lock defined in it is needed by the changes in drivers/hwmon/it87.c
> 

I dislike the idea of a single patch crossing multiple subsystems. Maybe you'll
find another maintainer accepting your change as a single patch, but I won't.

That doesn't mean that the patches would have to be committed into multiple trees.
That is for the subsystem maintainers to sort out, and a different issue.

Thanks,
Guenter
