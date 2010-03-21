Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab0CUHAY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 03:00:24 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:33405 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751568Ab0CUHAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 03:00:22 -0400
Date: Sun, 21 Mar 2010 08:00:15 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lars Lindley <lindley@coyote.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, gregkh@suse.de, greg@kroah.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: mlmetxrx_f.h Coding style fixes.
Message-ID: <20100321070015.GE11917@elf.ucw.cz>
References: <1268927857-14141-1-git-send-email-lindley@coyote.org>
 <4BA254BC.6090507@cs.helsinki.fi>
 <4BA2A68D.9050401@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA2A68D.9050401@coyote.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2010-03-18 23:17:49, Lars Lindley wrote:
> On 2010-03-18 17:28, Pekka Enberg wrote:
> > Lars Lindley wrote:
> >> I fixed all problems found by checkpatch.pl and removed CamelCase
> >> from argument names.
> ..snip..
> >> +void MLME_GetNextPacket(struct wbsoft_priv *adapter,
> >> +            struct wb35_descriptor *pdes);
> > 
> > Can we get rid of the "p" prefix (hungarian notation) while at it?
> > 
> Sure..
> I changed pdes to des, pmmpdu to mmpdu and widx to idx.
> Looks all right?
> 
> /Lars
> 
> 
> 
> Here is the new patch against master:
> 
> [PATCH] staging: winbond: mlmetxrx_f.h Coding style fixes.
> 
> I fixed all problems found by checkpatch.pl and removed CamelCase
> and hungarian notation from the argument names.
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
