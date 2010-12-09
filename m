Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab0LIJIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 04:08:37 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:55039 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab0LIJId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 04:08:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vX3nhEDZPsQxczZbMkmZ/YL8IgDHBim4Kg5Mnisl3ywOzhp1Z66crDQ6XYsFM5y1yM
         8knldhcd47NLQXsgJuAv2mB3ym9BvDbwHJRtGhEHbdAgX5fZeJnRK+Ssw9GhrokO5GtI
         HLK59CjxK2gRW1EDvc0iTksRsWOdF4MR9tric=
Date: Thu, 9 Dec 2010 01:08:26 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] input: mt updates for 2.6.38
Message-ID: <20101209090826.GB8821@core.coreip.homeip.net>
References: <4CFF49BC.8030202@euromail.se>
 <20101209085814.GA8821@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101209085814.GA8821@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 12:58:14AM -0800, Dmitry Torokhov wrote:
> On Wed, Dec 08, 2010 at 10:02:52AM +0100, Henrik Rydberg wrote:
> > Dmitry,
> > 
> > Please pull from
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rydberg/input-mt.git next
> > 
> > to receive input-mt updates for 2.6.38.
> > 
> > The tree contains core changes as well as dependent changes to hid drivers. You
> > also find the new hid-egalax driver in there, signed off by Jiri.
> 
> Pulled, thank you Henrik.
> 
> I wonder if we should move input-mt.h into input/mt.h (and if someone
> would bother to input-polldev.h there that would be great too).
> 
> Also I try to sync with mainline once per release, at -rc1, unless I
> know that my changes will conflict with some other work. I'd recommend
> you do the same so that when I pull from you I am getting just your
> changes and not the rest of stuff from mainline.
> 
> BTW, we need to document dev->trkid to avoid complaints from 'make
> htmldocs' and friends. I wonder if the patch below will do.
> 
> Thanks.
> 

And I think we need this one as well:

Input: include MT library as source for kerneldoc

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 Documentation/DocBook/device-drivers.tmpl |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 22edcbb..467beee 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -304,6 +304,10 @@ X!Idrivers/video/console/fonts.c
 !Edrivers/input/ff-core.c
 !Edrivers/input/ff-memless.c
      </sect1>
+     <sect1><title>Multitouch Library</title>
+!Iinclude/linux/input-mt.h
+!Edrivers/input/input-mt.c
+     </sect1>
      <sect1><title>Polled input devices</title>
 !Iinclude/linux/input-polldev.h
 !Edrivers/input/input-polldev.c

-- 
Dmitry
