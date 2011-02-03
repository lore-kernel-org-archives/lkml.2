Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab1BCVp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:45:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38171 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607Ab1BCVp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:45:26 -0500
Date: Thu, 3 Feb 2011 22:45:24 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: David Miller <davem@davemloft.net>
Cc: peter.chubb@nicta.com.au, linux-kernel@vger.kernel.org
Subject: Re: tcp_ecn is an integer not a boolean
In-Reply-To: <20110203.133558.189694852.davem@davemloft.net>
Message-ID: <alpine.LNX.2.00.1102032244300.2160@pobox.suse.cz>
References: <w4vd12m4it.wl%peter@chubb.wattle.id.au> <alpine.LNX.2.00.1102031126470.2160@pobox.suse.cz> <20110203.133558.189694852.davem@davemloft.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Feb 2011, David Miller wrote:

> >> There was some confusion at LCA as to why the sysctl tcp_ecn took one
> >> of three values when it was documented as a Boolean.  This patch fixes
> >> the documentation.
> >> 
> >> Signed-off-by: Peter Chubb <peter.chubb@nicta.com.au>
> >> 
> >> diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
> >> index d99940d..ac3b4a7 100644
> >> --- a/Documentation/networking/ip-sysctl.txt
> >> +++ b/Documentation/networking/ip-sysctl.txt
> >> @@ -187,7 +187,7 @@ tcp_cookie_size - INTEGER
> >>  tcp_dsack - BOOLEAN
> >>  	Allows TCP to send "duplicate" SACKs.
> >>  
> >> -tcp_ecn - BOOLEAN
> >> +tcp_ecn - INTEGER
> > 
> > Applied, thanks.
> 
> There is no need, did you see my reply?  I put it into the net-2.6
> GIT tree already.

Ah, no, I haven't, because Peter apparently originaly sent it to ancient 
trivial@rustcorp.com.au and only then bounced it to proper address, but 
your followup went to the old one as well.

OK, I will drop it, thanks for letting me know.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
