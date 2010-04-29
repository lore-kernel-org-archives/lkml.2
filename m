Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933816Ab0D3SFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:05:18 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:43348 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759025Ab0D3SC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:02:28 -0400
Date: Thu, 29 Apr 2010 14:14:14 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>,
       Henrik Kretzschmar <henne@nachtwindheim.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: section cleanup
Message-ID: <20100429121414.GC5275@secunet.com>
References: <1269672826-1102-1-git-send-email-henne@nachtwindheim.de>
 <20100329081550.GA22334@gondor.apana.org.au>
 <20100331145817.bd0a1a08.akpm@linux-foundation.org>
 <20100401081126.GC23247@secunet.com>
 <20100406120015.2ec46ba7@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100406120015.2ec46ba7@bike.lwn.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 29 Apr 2010 12:09:11.0340 (UTC) FILETIME=[C7012EC0:01CAE794]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 12:00:15PM -0600, Jonathan Corbet wrote:
> On Thu, 1 Apr 2010 10:11:26 +0200
> Steffen Klassert <steffen.klassert@secunet.com> wrote:
> 
> > I'm about to write some documentation for padata/pcrypt.
> 
> I hope that nobody minds if I went ahead and bashed something out?
> 
> 	http://lwn.net/SubscriberLink/382257/fe415ce242a12c15/
> 
> Comments welcome.  I'd be happy to rework it into a Documentation/ file
> if that would be useful.
> 

I wrote an article about parallelizing IPsec for the Linuxtag Conference
proceedings. This article covers also a section that describes the ideas of
padata on a formal level. I can send it if anybody is interested.

I'll send out the patches based on Andrew's review later today.

Steffen

PS: I'll be off for a week starting tomorrow evening, so I might not
respond during this time.
