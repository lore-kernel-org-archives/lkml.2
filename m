Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab1ELGRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 02:17:50 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:35320 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755002Ab1ELGRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 02:17:49 -0400
Date: Thu, 12 May 2011 06:17:43 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] PM / Wakeup: Fix build warning related to the "wakeup"
	sysfs file
Message-ID: <20110512061742.GA2460@localhost.ucw.cz>
References: <201105070050.55235.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105070050.55235.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2011-05-07 00:50:55, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The "wakeup" device sysfs file is only created if CONFIG_PM_SLEEP
> is set, so put it under CONFIG_PM_SLEEP and make a build warning
> related to it go away.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ack.
 
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
