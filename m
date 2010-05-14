Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab0ENPjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 11:39:05 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:35605 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab0ENPjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 11:39:03 -0400
Date: Fri, 14 May 2010 17:36:46 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add a document for the padata interface
Message-ID: <20100514153646.GA31557@secunet.com>
References: <20100512142917.4287bf6e@bike.lwn.net>
 <20100514105859.GA2184@secunet.com>
 <20100514092032.56a416ed@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514092032.56a416ed@bike.lwn.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 14 May 2010 15:38:56.0791 (UTC) FILETIME=[90B6DA70:01CAF37B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 09:20:32AM -0600, Jonathan Corbet wrote:
> On Fri, 14 May 2010 12:58:59 +0200
> Steffen Klassert <steffen.klassert@secunet.com> wrote:
> 
> > We disable the BHs before we call parallel(), so sleeping is not allowed.
> > This is necessary to keep up with the networking softirq if padata is used
> > for doing IPsec.
> 
> Oops...you didn't point that out last time :)
> 

Yes, I missed that when I read it last time :)

> I've updated that one sentence in the attached patch; everything else
> is the same.  Look good?
> 

Looks pretty good!

Thanks a lot,

Steffen
