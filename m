Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab0FLKde (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 06:33:34 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:60202 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753626Ab0FLKdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 06:33:32 -0400
Date: Sat, 12 Jun 2010 12:33:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: 2.6.35-rc{12} regression: inactive console corrupted
Message-ID: <20100612103321.GA1458@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

When something happens on inactive  console (using fbcon), display is
corrupted -- lines at end of screen are not erased properly.

I see it on zaurus, but I suspect problem is generic.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
