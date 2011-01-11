Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab1AKOeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 09:34:22 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:59085 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932248Ab1AKOeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 09:34:18 -0500
Date: Tue, 11 Jan 2011 15:34:17 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arthur Taylor <art@ified.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] New console keyboard mode OFF
Message-ID: <20110111143417.GD22390@atrey.karlin.mff.cuni.cz>
References: <AANLkTimqzWuGUvMo+8znuVbYocsnsJe7Heo+xY5jRrXv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimqzWuGUvMo+8znuVbYocsnsJe7Heo+xY5jRrXv@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The current console keyboard situation can be improved by introducing
> an "OFF" mode. All available modes for the console keyboard (RAW,
> MEDIUMRAW, XLATE, and UNICODE) buffer key events in the current vt's
> tty input. As recent Xorg releases no longer read input from the vt
> there are two problems:
> 
> 1) The tty input buffer eventually overflows because nothing is
> reading it, triggering an infinite flush_to_ldisc() kworker loop.
> 2) If the vt's mode isn't changed to RAW or MEDIUMRAW, key events
> remain translated by the kernel, causing shenanigans like pressing
> Ctrl+C in Xterm would send SIGTERM to the X server.

Seems very sane. Of course it all depends what a patch looks like...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
