Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab0C1MgV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 08:36:21 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:47375 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754304Ab0C1MgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 08:36:20 -0400
Date: Sun, 28 Mar 2010 14:36:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi,
       linville@tuxdriver.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: wb35rx.c Coding style fixes v2.
Message-ID: <20100328123609.GB1656@ucw.cz>
References: <1269758337-4120-1-git-send-email-lindley@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269758337-4120-1-git-send-email-lindley@coyote.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2010-03-28 08:38:57, Lars Lindley wrote:
> New patch that fixes an unclear comment too.
> 
> I fixed checkpatch issues except for long lines and printk:s.
> I also removed version comments and the () in a return statement.
> Generated .o is identical to master and i checked the code with
> Dan Carpenters strip_whitespace.pl and diff.
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>
> Acked-by: Dan Carpenter <error27@gmail.com>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
