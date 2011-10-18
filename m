Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab1JRBd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 21:33:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757052Ab1JRBd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 21:33:27 -0400
Date: Mon, 17 Oct 2011 21:33:20 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] Update email address for stable patch submission
Message-ID: <20111018013320.GR1165@zod.bos.redhat.com>
References: <20111018011638.GQ1165@zod.bos.redhat.com>
 <alpine.DEB.2.00.1110171826450.13515@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1110171826450.13515@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 06:28:57PM -0700, David Rientjes wrote:
> On Mon, 17 Oct 2011, Josh Boyer wrote:
> 
> > The stable@kernel.org email address has been replaced with the
> > stable@vger.kernel.org mailing list.  Change the stable kernel rules to
> > reference the new list instead of the semi-defunct email alias.
> > 
> > CC: <stable@kernel.org>
> > CC: <stable@vger.kernel.org>
> > Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> > 
> 
> Hmm, is stable@vger.kernel.org a replacement for stable@kernel.org or is 
> it just temporary until kernel.org is fully back to life?

To my understanding, stable@kernel.org is now just a forward to
stable@vger.kernel.org.  However, John mentioned that due to some
configuration issues the vger list might be dropping things from
stable@kernel.org on the floor.  So it's not working in a useful way at
the moment, and from what I can tell patches that need to be backported
and submitted to stable are kind of difficult to get in because of this.

Personally, I'd rather see the vger list take over entirely.  However,
that decision will remain in the more than capable hands of the admins.

josh
