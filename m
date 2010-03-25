Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab0CYOd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 10:33:29 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:58396 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753844Ab0CYOd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:33:28 -0400
Date: Thu, 25 Mar 2010 15:33:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi,
       harvey.harrison@gmail.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: wb35reg.c Coding style fixes v2.
Message-ID: <20100325143322.GB1657@ucw.cz>
References: <1269524693-27586-1-git-send-email-lindley@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269524693-27586-1-git-send-email-lindley@coyote.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2010-03-25 14:44:53, Lars Lindley wrote:
> I fixed the problems reported by checkpatch.pl excetp for
> long lines, a couple of printks and some warnings about usb_free_urb(NULL).
> I checked for regressions with Dan Carpenters strip_whitespace.pl
> and diff and everything looks good.
> Generated .o is identical to master.
> 
> This is a new patch against master where I fixed up a switch-statement
> after comments from Pavel Machek.
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>

Ack.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
