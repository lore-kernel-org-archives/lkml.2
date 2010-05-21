Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934359Ab0EURWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:22:36 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63199 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933577Ab0EURWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 13:22:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WpGLdGsNN7uT1OjBxglNBkPyq6zZ203yINMpGYjJwEFREqeYLepZLwdOwJ73YfZz1g
         zyqW7+cndinTh2oH5PTrurXVblIdpCkg8S1/ACP4SWWCNP5exR+w86kzzruJVsJfooTO
         n0T44uHz79M43zKxZReIBnIEBR6RJC6sl8DsM=
Date: Fri, 21 May 2010 10:22:22 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Ping Cheng <pinglinux@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev3)
Message-ID: <20100521172222.GB26439@core.coreip.homeip.net>
References: <1274457354-5570-1-git-send-email-rydberg@euromail.se>
 <AANLkTikBWzgRmso0oQNXcTxeExdKZORXYbIwK9CcMl85@mail.gmail.com>
 <4BF6B673.1080507@euromail.se>
 <20100521165218.GA26439@core.coreip.homeip.net>
 <4BF6BB43.2020405@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF6BB43.2020405@euromail.se>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 06:56:35PM +0200, Henrik Rydberg wrote:
> Dmitry Torokhov wrote:
> > On Friday 21 May 2010 09:36:03 am Henrik Rydberg wrote:
> >> Ping Cheng wrote:
> >>> Hi Henrik,
> >>>
> >>> Thank you for your quick turnaround. Two minor comments in line.
> >>>
> >>> Ping
> >> Thanks for those, yes, both mistakes. Dmitry, in case you find these last
> >> versions acceptable, perhaps one could change them manually:
> >>
> >> 1. Patch description: s/SYN_MT_SLOT/ABS_SLOT/
> > 
> > Not ABS_MT_SLOT?
> 
> I wrote an argument for ABS_SLOT in the first patch, in short there is a
> namespace clash I would like to avoid.
> 

Hm, I am not sure I follow that argument. While you are saying that slot
is not an MT event it is certainly not an ST event either. I would even
say that slot _is_ an MT event since it signals current "slot" or group
of MT data to userspace. Am I missing something?

-- 
Dmitry
