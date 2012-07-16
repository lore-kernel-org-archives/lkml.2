Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab2GPQTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 12:19:31 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42837 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab2GPQT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 12:19:29 -0400
Date: Mon, 16 Jul 2012 18:19:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120716161913.GB20549@elf.ucw.cz>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <20472.466.594018.973876@pilspetsen.it.uu.se>
 <20120710101223.GF15120@arm.com>
 <20120714093505.GB23316@elf.ucw.cz>
 <20120715113631.GA10597@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120715113631.GA10597@arm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The assembly syntax is very reasonable already and not far from what we
> are used to (see the .S files in my kernel patches). The 64-bit
> instructions are different and that's specified here (apart from the
> actual bit encoding):
> 
> http://infocenter.arm.com/help/topic/com.arm.doc.genc010197a/index.html

"This document is only available in a PDF version to registered ARM
customers."

It would be nice to make this public :-(.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
