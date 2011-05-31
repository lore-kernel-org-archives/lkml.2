Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125Ab1EaToW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 15:44:22 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:48723 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754200Ab1EaToV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 15:44:21 -0400
Date: Tue, 31 May 2011 21:43:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [kernel.org users] Turning off the incremental diff robot
Message-ID: <20110531194358.GA4424@elf.ucw.cz>
References: <4DE3E9E7.8020008@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE3E9E7.8020008@zytor.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> With the v3.0 name change I was looking over what might break, and I'm
> seriously considering turning off the incremental diff robot on
> kernel.org.  It's not clear to me that it is actually useful anymore,
> with git and all.
> 
> Do anyone actually use these anymore?

Yes.

Usecase one is zaurus, which is just not powerful enough for git, and
usecase two are companies that only work with releases... ketchup is
very useful for both.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
