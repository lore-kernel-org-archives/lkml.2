Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab1FFKxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 06:53:21 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57104 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755191Ab1FFKxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 06:53:17 -0400
Date: Thu, 2 Jun 2011 05:14:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: 3.0-rc1: loud fan on thinkpadx60
Message-ID: <20110602031440.GB1565@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Normally, x60 steps fans bit by bit when temperature increases, and
keeps fans low (2800rpm?) while idle.

On 3.0-rc1, fans go to high speed (4100?) even when idle.

Ideas? Anyone else sees it?

(One possibility is ethernet overheat. I had fun with that before.)
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
