Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119Ab1DYIig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 04:38:36 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:34023 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756650Ab1DYIif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 04:38:35 -0400
Date: Mon, 25 Apr 2011 10:38:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mike Frysinger <vapier@gentoo.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] freezer: use smp barriers
Message-ID: <20110425083832.GA3770@elf.ucw.cz>
References: <1303716665-27584-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303716665-27584-1-git-send-email-vapier@gentoo.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2011-04-25 03:31:05, Mike Frysinger wrote:
> The freezer processes are dealing with multiple threads running
> simultaneously, and on a UP system, the memory reads/writes do
> not need barriers to keep things in sync.  These are only needed
> on SMP systems, so use SMP barriers instead.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
