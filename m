Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab0EGHeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 03:34:09 -0400
Received: from ist.d-labs.de ([213.239.218.44]:56973 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032Ab0EGHeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 03:34:07 -0400
X-Greylist: delayed 1905 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 May 2010 03:34:07 EDT
Date: Fri, 7 May 2010 09:02:18 +0200
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get_maintainer.pl: ignore non-maintainer tags
Message-ID: <20100507070218.GA6574@home.mickler.org>
References: <1273179148.1537.145.camel@Joe-Laptop.home>
 <1273214095-23396-1-git-send-email-florian@mickler.org>
 <1273214367.1540.21.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273214367.1540.21.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 11:39:26PM -0700, Joe Perches wrote:
> On Fri, 2010-05-07 at 08:34 +0200, florian@mickler.org wrote:
> > Using --git to determine who to send a patch to, it is not
> > reasonable to include people that only reported an issue or tested a
> > patch.
> 
> I think this is a questionable assumption.
> 
> People that test or otherwise sign a patch are also good
> candidates to review new patches.
> 
> cheers, Joe

Our views differ then.

It is unreasonable to assume, that someone who is listed via
Tested-By: in a random patch is able to review another patch to the same
file. More likely will he be annoyed, because he see's a patch, dig's
in and then thinks: "wtf? why were i cc'ed on this. I don't know this
code. I don't have time for this!"

Thats just broken.

cheers,
Flo


