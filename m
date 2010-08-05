Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773Ab0HEG2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 02:28:24 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:36163 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759754Ab0HEG2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 02:28:18 -0400
Date: Thu, 5 Aug 2010 08:26:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Bojan Smojver <bojan@rexursive.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
Message-ID: <20100805062604.GB1546@ucw.cz>
References: <1280465201.2600.10.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280465201.2600.10.camel@shrek.rexursive.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This patch speeds up hibernate/thaw operations (in kernel ones) by
> compressing the pages using LZO. Tests on my ThinkPad T510 show that
> hibernation times can be cut by the factor of about 4 for an image of
> around 1 GB (from about a minute down to about 15 seconds).

Why do it in kernel? s2disk should already be faster...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
