Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab1DSQ2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 12:28:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63639 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab1DSQ2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 12:28:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r03kyZs+hLt/RwvQNq53o+pV9xT9Yk4ZoFd22/cauwHQJooigTw6bs59SF5iOuyD8i
         yida/E54R05JJyLbeakQALJP839/t3a6FJHAIWxwZ5S361qf1ascaMIg9yV1qpn9J+zo
         XGvIMIYR0OQOEBHR0dhxNfERYRdllyKVR/TMM=
Date: Tue, 19 Apr 2011 18:26:04 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Ian Romanick <idr@freedesktop.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 2/2] drm: Verify debug message arguments
Message-ID: <20110419162604.GA2861@joi.lan>
References: <cover.1303097621.git.joe@perches.com>
 <c24620769d5864c0c0e460358b256acd0ada5c79.1303097621.git.joe@perches.com>
 <4DACC2B9.3020200@freedesktop.org>
 <1303168151.31723.50.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303168151.31723.50.camel@Joe-Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 04:09:11PM -0700, Joe Perches wrote:
> On Mon, 2011-04-18 at 16:01 -0700, Ian Romanick wrote:
> > > @@ -214,9 +214,9 @@ parse_lfp_panel_data(struct drm_i915_private *dev_priv,
> > >  	    i915_lvds_downclock) {
> > >  		dev_priv->lvds_downclock_avail = 1;
> > >  		dev_priv->lvds_downclock = temp_downclock;
> > > -		DRM_DEBUG_KMS("LVDS downclock is found in VBT. ",
> > > -				"Normal Clock %dKHz, downclock %dKHz\n",
> > > -				temp_downclock, panel_fixed_mode->clock);
> > > +		DRM_DEBUG_KMS("LVDS downclock is found in VBT. "
> > > +			      "Normal Clock %dKHz, downclock %dKHz\n",
> > > +			      temp_downclock, panel_fixed_mode->clock);
> > >  	}
> > >  	return;
> > >  }
> > Does this hunk only change white space, or am I missing something?
> 
> No, you're right.  It's just whitespace.
> I prefer arguments aligned to open paren.

It's not just whitespace. Look at the end of first line.

Marcin

