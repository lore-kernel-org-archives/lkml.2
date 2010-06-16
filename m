Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734Ab0FPGvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 02:51:09 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:43804 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754947Ab0FPGvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 02:51:06 -0400
Date: Wed, 16 Jun 2010 08:50:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.35-rc{12} regression: inactive console corrupted
Message-ID: <20100616065055.GA4112@elf.ucw.cz>
References: <20100612103321.GA1458@ucw.cz>
 <201006152238.12022.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006152238.12022.maciej.rutecki@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > When something happens on inactive  console (using fbcon), display is
> > corrupted -- lines at end of screen are not erased properly.
> > 
> > I see it on zaurus, but I suspect problem is generic.
> 
> I created a Bugzilla entry at 
> https://bugzilla.kernel.org/show_bug.cgi?id=16222
> for your bug report, please add your address to the CC list in there, thanks!

It seems that problem is fixed in -rc3... this one can be closed.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
