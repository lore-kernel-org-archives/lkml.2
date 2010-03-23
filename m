Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab0CWIub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 04:50:31 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:51408 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751837Ab0CWIu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 04:50:29 -0400
Date: Tue, 23 Mar 2010 09:50:28 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: wb35reg_s.h Coding styls fixes.
Message-ID: <20100323085028.GC27015@atrey.karlin.mff.cuni.cz>
References: <1269280798-7848-1-git-send-email-lindley@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269280798-7848-1-git-send-email-lindley@coyote.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I fixed all problems reported by checkpatch.pl except
> some long lines. I also removed commented away code and
> revision comments.
> Checked for regressions with Dan Carpenters
> strip_whitespace.pl and diff.
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
