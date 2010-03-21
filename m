Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab0CUU0a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 16:26:30 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:48912 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752613Ab0CUU03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 16:26:29 -0400
Date: Sun, 21 Mar 2010 21:26:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Lars Lindley <lindley@coyote.org>, gregkh@suse.de, greg@kroah.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: sme_api.h Coding style fixes.
Message-ID: <20100321202622.GJ1933@elf.ucw.cz>
References: <1269190503-12050-1-git-send-email-lindley@coyote.org>
 <20100321201221.GI1933@elf.ucw.cz>
 <84144f021003211325m7ab3f65ej901c6ad93cab8c69@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f021003211325m7ab3f65ej901c6ad93cab8c69@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >> @@ -18,42 +12,42 @@
> >>  #include "localpara.h"
> >>
> >>  /****************** CONSTANT AND MACRO SECTION ******************************/
> >> -#define _INLINE      __inline
> >> +#define _INLINE                              __inline
> >
> > doing s/_INLINE/__inline/ on whole sources would be nice....
> 
> We probably can just get rid of most of the inlines in the driver
> code, I think.

Yes. I do not think this driver is performance-critical, and GCC can
probably outsmart us.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
