Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714Ab0C0GHF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 02:07:05 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:58513 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751255Ab0C0GHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 02:07:02 -0400
Date: Sat, 27 Mar 2010 07:06:50 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: wb35tx_s.h Coding style fixes.
Message-ID: <20100327060649.GB18689@elf.ucw.cz>
References: <1269615817-3565-1-git-send-email-lindley@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269615817-3565-1-git-send-email-lindley@coyote.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2010-03-26 16:03:37, Lars Lindley wrote:
> I fixed all reported checkpatch issues.
> I also removed versioning comments.
> I checked for oopses with Dan Carpenters strip_whitespace.pl
> and diff.
> 
> Signed-off-by: <lindley@coyote.org>

Please add your name here. 

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
