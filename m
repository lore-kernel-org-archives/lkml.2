Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab0FUPPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 11:15:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63131 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955Ab0FUPPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 11:15:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HEX1JgN/yK4vrMv0ouwtGjFsJkmYy7s4FcKo3S0vHzscnbUtpmrq6AqPa8srDn1DD3
         8kI5ZDAybhwUDuu7ZIWdcEcyOOWK43iB931Lr/DQWp6mXNf/rEWNpkpN/taPQMKp6NxO
         /aI2sIFTkB3yM0TluxOT4KTwtRwYrW2Fu8Wyc=
Date: Mon, 21 Jun 2010 19:15:34 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: mike@compulab.co.il, linux-kernel@vger.kernel.org, vilensky@compulab.co.il,
       mike.rapoport@gmail.com
Subject: Re: [PATCH] ds2782: Fix ds2782_get_capacity return value
Message-ID: <20100621151534.GA16771@oksana.dev.rtsoft.ru>
References: <1276562699-4933-1-git-send-email-ryan@bluewatersys.com>
 <4C1E898D.8010902@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4C1E898D.8010902@bluewatersys.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 09:35:09AM +1200, Ryan Mallon wrote:
> On 06/15/2010 12:44 PM, Ryan Mallon wrote:
> > The ds2782_get_capacity function should return 0 on success, not the
> > capacity value.
> > 
> > Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
> > ---
> >  drivers/power/ds2782_battery.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
> > index d762a0c..2afbeec 100644
> > --- a/drivers/power/ds2782_battery.c
> > +++ b/drivers/power/ds2782_battery.c
> > @@ -163,7 +163,7 @@ static int ds2782_get_capacity(struct ds278x_info *info, int *capacity)
> >  	if (err)
> >  		return err;
> >  	*capacity = raw;
> > -	return raw;
> > +	return 0;
> >  }
> >  
> >  static int ds2786_get_current(struct ds278x_info *info, int *current_uA)
> 
> Ping, Anton?

Applied to battery-2.6.35.git, thanks!
