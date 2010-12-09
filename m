Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab0LITG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 14:06:26 -0500
Received: from mail-yw0-f66.google.com ([209.85.213.66]:63325 "EHLO
	mail-yw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579Ab0LITGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 14:06:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dp6zEbBFWV27sEm6YsZ8Jr/XTZHLjDjwjZyV5uU4xLzlYpBvBmVYG0yzrk6nzcRz6U
         frawdQj1SVlS+4R4y2sIPpcmnV62RE9dmKLoiNobjobe5hCvjBe2y7LsQxvzL2i5TnhR
         OVvs/+BVnHAef7fSR2UZm9/TG11+jVAKWn4kw=
Date: Thu, 9 Dec 2010 10:49:41 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] input: mt updates for 2.6.38
Message-ID: <20101209184940.GB23781@core.coreip.homeip.net>
References: <4CFF49BC.8030202@euromail.se>
 <20101209085814.GA8821@core.coreip.homeip.net>
 <4D011EA3.2000905@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D011EA3.2000905@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 07:23:31PM +0100, Henrik Rydberg wrote:
> On 12/09/2010 09:58 AM, Dmitry Torokhov wrote:
> 
> > On Wed, Dec 08, 2010 at 10:02:52AM +0100, Henrik Rydberg wrote:
> >> Dmitry,
> >>
> >> Please pull from
> >>
> >>   git://git.kernel.org/pub/scm/linux/kernel/git/rydberg/input-mt.git next
> >>
> >> to receive input-mt updates for 2.6.38.
> >>
> >> The tree contains core changes as well as dependent changes to hid drivers. You
> >> also find the new hid-egalax driver in there, signed off by Jiri.
> > 
> > Pulled, thank you Henrik.
> > 
> > I wonder if we should move input-mt.h into input/mt.h (and if someone
> > would bother to input-polldev.h there that would be great too).
> 
> 
> Sure, I have been wondering about that too. Right away, or later?

Better sooner than later as you'll have less places to patch ;)

> 
> > Also I try to sync with mainline once per release, at -rc1, unless I
> > know that my changes will conflict with some other work. I'd recommend
> > you do the same so that when I pull from you I am getting just your
> > changes and not the rest of stuff from mainline.
> 
> 
> No problem - I will see what sync point you end up using, and I will rebase to
> the same point.

No, not rebase, pull please. Public branches should not be rebased, at
least not when they have been pulled from.

> 
> > BTW, we need to document dev->trkid to avoid complaints from 'make
> > htmldocs' and friends. I wonder if the patch below will do.
> 
> 
> Looks good, thanks.

OK. I take it as an acked-by then.

-- 
Dmitry
