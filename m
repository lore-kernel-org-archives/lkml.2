Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935410Ab2JaKhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 06:37:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35043 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932896Ab2JaKhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 06:37:07 -0400
Date: Wed, 31 Oct 2012 11:37:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>,
        Adil Mujeeb <mujeeb.adil@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] checkpatch: Emit a warning when decimal values are
 used
Message-ID: <20121031103703.GA12648@elf.ucw.cz>
References: <cover.1351578285.git.joe@perches.com>
 <497a03b1726dda76e0fd49d5ea8d3514da2d0128.1351578285.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497a03b1726dda76e0fd49d5ea8d3514da2d0128.1351578285.git.joe@perches.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Linux kernel doesn't like decimals, say so.

?!

Linux surely supports decimal constants, like "100". Did you mean
"octal"?

If you wanted to add warning for something... I never want to see

#define CRAPPY_EMBEDDED_REGISTER ((0x1) << (0))

again....
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
