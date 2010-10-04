Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab0JDRvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 13:51:16 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:34298 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753798Ab0JDRvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 13:51:15 -0400
Date: Mon, 4 Oct 2010 19:51:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [linux-pm] [PATCH 07/23] Hiberation: Fix speed display.
Message-ID: <20101004175104.GA1518@ucw.cz>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
 <1285566238-10966-8-git-send-email-nigel@tuxonice.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285566238-10966-8-git-send-email-nigel@tuxonice.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2010-09-27 15:43:42, Nigel Cunningham wrote:
> Correct the situation where, if an error occurs while writing an image,
> the speed display still uses the number of pages that should have been
> written, rather than the number of pages that were written.
> 
> Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>

Ack.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
