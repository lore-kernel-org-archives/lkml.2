Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab0JDRzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 13:55:07 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57924 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755911Ab0JDRzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 13:55:06 -0400
Date: Mon, 4 Oct 2010 19:54:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [linux-pm] [PATCH 03/23] Hibernation: Swap iteration functions.
Message-ID: <20101004175457.GC1518@ucw.cz>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
 <1285566238-10966-4-git-send-email-nigel@tuxonice.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285566238-10966-4-git-send-email-nigel@tuxonice.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2010-09-27 15:43:38, Nigel Cunningham wrote:
> Add the data structure 'storage_position' and routines that allow
> a caller to iterate over swap in sector order. Note that calling
> reset_storage_pos only resets the position. next_swapdev_block
> must also be called to get the address of the first (and subsequent
> sectors).
> 
> Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>

Merge this with 8/23? AFAICT, this creates unused functions here only
to move them in later patch.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
