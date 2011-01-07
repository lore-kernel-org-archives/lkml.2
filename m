Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab1AGR24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 12:28:56 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50103 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab1AGR2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 12:28:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tk4rdNi2xsp/4WHzFgj+yAgp1w5X1M1OBKJKwSXMO4vcgZntPzNXSf0Q5rHZNRt76B
         Pr5dzr/u4Vo0lVTC7XqzmUHcd/GVrUVIHiuDXWK8gRO4k15MrpINuQGWJjdPeNV9hz2l
         KqsJlT+DAv1Lf7Y4wiqJNW4DkL6MWvGhZEEAI=
Date: Fri, 7 Jan 2011 09:28:47 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "James T. Dickson" <james.dickson@jtdata.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: introduce 'notimeout' blacklist for Dell Vostro
 V13 (was Re: Synaptics touchpad on Dell Vostro V13)
Message-ID: <20110107172847.GA28785@core.coreip.homeip.net>
References: <8583070.26.1294325869588.JavaMail.root@butch.jtdata.net>
 <alpine.LNX.2.00.1101071105350.26685@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1101071105350.26685@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 11:06:41AM +0100, Jiri Kosina wrote:
> On Thu, 6 Jan 2011, James T. Dickson wrote:
> 
> > Correct .. Suspend worked fine when the touchpad was a generic mouse.
> > 
> > However, this appears a symptom of the synaptics driver. I was able to 
> > overcome it with this script from 
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/59867 .
> > 
> > Placing it in /etc/pm/sleeps.d/ .
> > 
> > #!/bin/sh
> > #
> > # Reload the AT keyboard interface.
> > 
> > case "$1" in
> >         hibernate|suspend)
> >                 rmmod psmouse
> >                 ;;
> >         thaw|resume)
> >                 modprobe psmouse
> >                 ;;
> >         *)
> >                 ;;
> > esac
> 
> I have already came across reports of this being needed for synaptics 
> touchpads on several different machines already, so this seems to be 
> rather unrelated problem to me.

Right, but it would be nice if we could find the problem...

> 
> Dmitry, what is your current plan with the notimeout thing for V13, 
> please? Still .38 material?

Yeah, especially given that not all V13 seem to suffer from
suspend/resume issue.

-- 
Dmitry
