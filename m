Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab0JTW7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 18:59:39 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:2279 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab0JTW7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 18:59:37 -0400
Date: Wed, 20 Oct 2010 19:59:29 -0300
From: Leandro Lucarella <luca@llucax.com.ar>
To: Jon Maloy <jon.maloy@ericsson.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
	<tipc-discussion@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Miller <davem@davemloft.net>
Subject: Re: Linux 2.6.35/TIPC 2.0 ABI breaking changes
Message-ID: <20101020225929.GT8781@llucax.com.ar>
References: <20101019.011649.71113115.davem@davemloft.net>
 <20101019110452.GA14410@hmsreliant.think-freely.org>
 <20101019131936.GB8781@llucax.com.ar>
 <20101019201841.GC14410@hmsreliant.think-freely.org>
 <20101020172018.GN8781@llucax.com.ar>
 <0434463FDA60A94FA978ACA44617682DEE84668199@EUSAACMS0702.eamcs.ericsson.se>
 <20101020180454.GC14407@hmsreliant.think-freely.org>
 <0434463FDA60A94FA978ACA44617682DEE846681B9@EUSAACMS0702.eamcs.ericsson.se>
 <20101020182851.GP8781@llucax.com.ar>
 <20101020192350.GR8781@llucax.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101020192350.GR8781@llucax.com.ar>
X-Paranoid: Just because you're paranoid, don't mean they're not after you.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leandro Lucarella, el 20 de octubre a las 16:23 me escribiste:
> Leandro Lucarella, el 20 de octubre a las 15:28 me escribiste:
> > Jon Maloy, el 20 de octubre a las 14:10 me escribiste:
> > > <...>
> > > > > 
> > > > > Remember, permitting both is a superset of the current one 
> > > > (NBO only) 
> > > > > so it is fully backwards compatible. We break absolutly nothing by 
> > > > > permitting this.
> > > > > 
> > > > Thats effectively reverting both our patches though, isn't it 
> > > > (not that I'm disagreeing with it, just looking for 
> > > > clarification).  If we revert my patch and reintroduce the 
> > > > htohl mechanism which tracks endianess, we might as well 
> > > > revert the TIPC_SUB_SERVICE flag as well, yeah?
> > > 
> > > Absolutely. I think it was a mistake to change that value.
> > > But I don't think we need to reintroduce the htohl(). That
> > > was just one way of doing it. If I understood your suggestion
> > > from yesterday correctly you converted the whole message within
> > > one if()clause, without any htohl(). I have have no problem with 
> > > that approach.
> > 
> > There is a difference between both solutions, the htohl() version
> > tracked the need for swap as a struct subscription member (which was
> > used when sending back events). Neils patch doesn't do that tracking.
> > I don't really know the implications of this, but maybe it would be
> > a wise idea to stay in the safe side and revert both patches for now.
> 
> BTW, I tried 2.6.37 reverting both offending patches and everything
> seems to work well.

I meant 2.6.35.7.

-- 
Leandro Lucarella (AKA luca)                     http://llucax.com.ar/
----------------------------------------------------------------------
GPG Key: 5F5A8D05 (F8CD F9A7 BF00 5431 4145  104C 949E BFB6 5F5A 8D05)
----------------------------------------------------------------------
Karma police
arrest this girl,
her Hitler hairdo
is making me feel ill
and we have crashed her party.
