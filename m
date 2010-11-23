Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab0KWPGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 10:06:19 -0500
Received: from io.pong.be ([68.233.169.42]:58072 "EHLO io.pong.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060Ab0KWPGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 10:06:18 -0500
X-Greylist: delayed 1303 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Nov 2010 10:06:18 EST
Date: Tue, 23 Nov 2010 09:44:28 -0500
From: Ward Vandewege <ward@gnu.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Bernie Innocenti <bernie@codewiz.org>, lkml <linux-kernel@vger.kernel.org>,
        Jan Seiffert <kaffeemonster@googlemail.com>, netdev@vger.kernel.org
Subject: Re: pc300too on a modern kernel?
Message-ID: <20101123144428.GA18504@countzero.vandewege.net>
Mail-Followup-To: Ward Vandewege <ward@gnu.org>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Bernie Innocenti <bernie@codewiz.org>,
	lkml <linux-kernel@vger.kernel.org>,
	Jan Seiffert <kaffeemonster@googlemail.com>, netdev@vger.kernel.org
References: <20100902131531.GA19028@countzero.vandewege.net>
 <m3mxrw1lg0.fsf@intrepid.localdomain>
 <1289421869.9336.49.camel@giskard.codewiz.org>
 <m3sjz34mka.fsf@intrepid.localdomain>
 <1289944619.2677.22.camel@giskard.codewiz.org>
 <m3tyjd7za9.fsf@intrepid.localdomain>
 <1290442675.5515.92.camel@giskard.codewiz.org>
 <m38w0l2gzh.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m38w0l2gzh.fsf@intrepid.localdomain>
X-message-flag: Outlook (Express) is an extremely dangerous program that
 will get you all sorts of nasty viruses.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-detected-operating-system: by mail.pong.be: Error: This connection is not (no longer?) in the cache.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 10:20:02PM +0100, Krzysztof Halasa wrote:
> > With this workaround applied, we're st seeing occasional clusters of
> > packet loss. We're working to graph the ping loss alongside traffic to
> > see if there's any correlation.
> 
> That's interesting. I remember seeing some TX underruns at higher
> speeds, though nothing alike at 2 Mb/s. What bit rate are you using?
> Does "ifconfig hdlc0" show any errors?

This turned out to be caused by line saturation. We were not seeing this
before we upgraded to the latest kernel because we have a set of qos rules
that we forgot to install on our new box. Mea culpa...

Thanks,
Ward.

-- 
Ward Vandewege <ward@gnu.org>
