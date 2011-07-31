Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab1GaRkx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 13:40:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54810 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab1GaRkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 13:40:47 -0400
Date: Sun, 31 Jul 2011 19:39:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v3 0/6] notifier error injection
Message-ID: <20110731173944.GA1620@ucw.cz>
References: <1311411060-30124-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311411060-30124-1-git-send-email-akinobu.mita@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This provides kernel modules that can be used to test the error handling
> of notifier call chain failures by injecting artifical errors to the
> following notifier chain callbacks.
> 
>  * CPU notifier
>  * PM notifier
>  * memory hotplug notifier
>  * powerpc pSeries reconfig notifier
...

>  11 files changed, 680 insertions(+), 38 deletions(-)

Do we really need this debugging code in mainline? How many bugs did
it find?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
