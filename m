Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab0LAT4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 14:56:42 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:54665 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755529Ab0LAT4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 14:56:41 -0500
Date: Wed, 1 Dec 2010 20:56:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, gregkh@elf.ucw.cz
Subject: Re: [PATCH] add netdev led trigger
Message-ID: <20101201195638.GE15294@elf.ucw.cz>
References: <1289768305-1224-1-git-send-email-ecc@cmu.edu>
 <20101117105925.GC1574@ucw.cz>
 <20101117160919.GC10992@kroah.com>
 <20101117195843.GA31357@elf.ucw.cz>
 <20101117200614.GK15096@localhost>
 <20101130192053.GB5295@ucw.cz>
 <20101130232204.GF21496@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101130232204.GF21496@localhost>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Please be consistent with rest of kernel...
> 
> There seem to be several ways this is done in existing sysfs drivers,
> and most aren't documented yet in Documentation/ABI.

Greg is official sysfs maintainer.

> 1. "0" and "1"

This should do the trick.

> 2. "enable" and "disable"
> 3. "enabled" and "disabled"
> 4. "enable" and "disable" when writing, but "enabled" and "disabled"
>     when read back
> 
> Some require trailing "\n", others make it optional.
> 
> Which is the One True Way?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
