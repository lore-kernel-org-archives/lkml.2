Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482Ab1EZURg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:17:36 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:53737 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757985Ab1EZURf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:17:35 -0400
Date: Thu, 26 May 2011 22:17:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: David Safford <safford@watson.ibm.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        Greg KH <greg@kroah.com>, Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: [PATCH v5 00/21] EVM
Message-ID: <20110526201725.GC15959@elf.ucw.cz>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
 <20110518172552.6d482c7a.akpm@linux-foundation.org>
 <20110526060842.GA13933@localhost.ucw.cz>
 <4DDE80FE.7010005@schaufler-ca.com>
 <1306433514.24986.26.camel@localhost.localdomain>
 <20110526183849.GA4563@ucw.cz>
 <1306439347.3092.89.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306439347.3092.89.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2011-05-26 15:49:07, Mimi Zohar wrote:

> > > Whether or not the phone is rooted, IMA-Appraisal, EVM, and 
> > > the Digital Signature Extensions help protect against remote
> > > software attacks, and offline hardware attacks on individual
> > > files, but not against rooting itself.
> > 
> > As far as I can tell, file signatures only prevent "offline hardware
> > attacks"; that is  user trying to "attack" (== root) his own computer.
> 
> Since when is my being able to detect and prevent unauthorized/malicious
> files on my own system (eg. device - VM) from being read/executed deemed
> evil?!  Are you suggesting that we're better off not knowing the

Well, unauthorized files should not get onto your system in the first
place -- and the kernel can do that already, see for example the
immutable bit. Only added bit of prevention seems to be "if someone
takes the disk out and modifies the filesystem offline".

Normally, you protect against that by not giving your disk to
strangers. (And file signatures are useless because the stranger can
replace your kernel, too).

> integrity or authenticity of a file?  I suggest you read Dave's
> Integrity Overview whitepaper?

I suggest you explain the patchset in the emails, then? Everyone here
seems to be confused... Attack it protects against, and what kind of
hardware is needed for the protection to be effective?

Because AFAICT, file signatures, as proposed, are only useful for
locking down my cellphone against myself. (That's -- evil).

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
