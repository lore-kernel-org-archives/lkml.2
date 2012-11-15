Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767528Ab2KOLGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 06:06:52 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42460 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993226Ab2KOLGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 06:06:50 -0500
Date: Thu, 15 Nov 2012 12:06:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: hpa@linux.intel.com, mchehab@redhat.com
Subject: Wrong defaults in 3.7-rc3
Message-ID: <20121115110620.GA3451@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Supervisor Mode Access Prevention (X86_SMAP) [Y/n/?] (NEW)

...Slows stuff down, eats memory, only works on unreleased Intel CPUs
(from 2013!)  perhaps should be off by default?

"Supervisor Mode Access Prevention (SMAP) is a security
feature in newer Intel processors.  There is a small
performance cost if this enabled and turned on; there is
also a small increase in the kernel size if this is enabled."

Perhaps help text should mention what processors support it?

  DiBcom DiB0070 silicon base-band tuner (DVB_TUNER_DIB0070) [M/n/y/?]
  (NEW) n
  DiBcom DiB0090 silicon base-band tuner (DVB_TUNER_DIB0090) [M/n/y/?]
  (NEW) n

M is never good config default.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
