Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab1EIWgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:36:49 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21145 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab1EIWgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 18:36:47 -0400
Date: Tue, 10 May 2011 00:29:50 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Please don't hijack patches - even trivial ones (was: Re: [PATCH
 13/14] HPFS: Move declaration up, so that there are no out-of-scope
 pointers=
In-Reply-To: <alpine.DEB.2.00.1105100023220.13325@artax.karlin.mff.cuni.cz>
Message-ID: <alpine.LNX.2.00.1105100022400.19722@swampdragon.chaosbits.net>
References: <alpine.DEB.2.00.1105082031050.7013@artax.karlin.mff.cuni.cz> <alpine.LNX.2.00.1105092215450.19722@swampdragon.chaosbits.net> <alpine.DEB.2.00.1105100023220.13325@artax.karlin.mff.cuni.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 May 2011, Mikulas Patocka wrote:

> 
> 
> On Mon, 9 May 2011, Jesper Juhl wrote:
> 
> > On Sun, 8 May 2011, Mikulas Patocka wrote:
> > 
> > > Move declaration up, so that there are no out-of-scope pointers
> > > 
> > > Reported-by: Jesper Juhl <jj@chaosbits.net>
> > > Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
> > > 
> 
> So change it to:
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
Kinda hard when it's already merged in mainline ;-)


> > Hmm. I'm a little currious how my original Signed-off-by got turned into a 
> > Reported-by for this patch?
> 
> I don't know. I probably checked the code independently after your report 
> and ended up fixing exactly the same thing that you fixed.
> 
Just seems a little odd that you would check the code based on my report 
(you must have been aware of it given the reported-by) and then ending up 
with the exact same fix would chose to submit a completely new patch with 
the exact same contents but with you as author...

Ohh well, never mind - it's a trivial patch and the important thing is 
that it got merged. I just got a little annoyed at seeing a patch that I 
had submitted and even ping'ed people about later, getting merged with a 
different author and me just listed as 'reported-by'... I just care about 
these things, even for trivial stuff - it's a matter of "credit where 
credit is due" even when the change is minor...

but let's just leave it where it is - the fix got merged, that's the 
really important bit :-)

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

