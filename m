Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab2AMSBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 13:01:25 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60123 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758609Ab2AMSBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 13:01:23 -0500
Date: Fri, 13 Jan 2012 19:01:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Matthieu CASTET <castet.matthieu@free.fr>
Cc: linux-acpi@vger.kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rjw@sisk.pl
Subject: Re: [PATCH 1/2] merge 32 and 64 realmode wakeup code
Message-ID: <20120113180121.GA9433@atrey.karlin.mff.cuni.cz>
References: <1324066385-8491-1-git-send-email-castet.matthieu@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324066385-8491-1-git-send-email-castet.matthieu@free.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - this mean less ifdef in code
> - we could remove now unused field in wakeup_header (pmode_*)
> 
> Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>

Looks good... was it tested on both 32 and 64 bit?

> -	/* This really couldn't... */
> -	movl	pmode_cr0, %eax
> -	movl	%eax, %cr0
> -	jmp	pmode_return

How was this handled?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
