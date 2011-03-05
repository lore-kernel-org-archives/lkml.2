Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab1CEFov (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 00:44:51 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:37392 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751110Ab1CEFou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 00:44:50 -0500
Date: Sat, 5 Mar 2011 06:44:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: 2.6.38-rc6+: oops while hibernating, pcmcia?
Message-ID: <20110305054426.GA2096@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Unfortunately it did not made it do disk. Thinkpad x60. PCMCIA was in
the backtrace, and yes, I had CF card in the PCMCIA slot. Certainly
not 100% repeatable, as it was 3rc hibernate or so...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
