Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab1JRCy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 22:54:56 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:36562 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752485Ab1JRCyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 22:54:55 -0400
X-Sasl-enc: CWPT7aQAXkVhKgS2U71hntJ2ufyI7ad/KFseRYWkiBuR 1318906494
Date: Mon, 17 Oct 2011 19:54:02 -0700
From: Greg KH <greg@kroah.com>
To: David Rientjes <rientjes@google.com>
Cc: Josh Boyer <jwboyer@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Update email address for stable patch submission
Message-ID: <20111018025402.GA6475@kroah.com>
References: <20111018011638.GQ1165@zod.bos.redhat.com>
 <alpine.DEB.2.00.1110171826450.13515@chino.kir.corp.google.com>
 <20111018013320.GR1165@zod.bos.redhat.com>
 <alpine.DEB.2.00.1110171833470.13515@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1110171833470.13515@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 06:37:48PM -0700, David Rientjes wrote:
> On Mon, 17 Oct 2011, Josh Boyer wrote:
> 
> > > Hmm, is stable@vger.kernel.org a replacement for stable@kernel.org or is 
> > > it just temporary until kernel.org is fully back to life?
> > 
> > To my understanding, stable@kernel.org is now just a forward to
> > stable@vger.kernel.org.
> 
> Right, but the question is whether that's temporary or permanent.

Permanent.

> > Personally, I'd rather see the vger list take over entirely.  However,
> > that decision will remain in the more than capable hands of the admins.
> > 
> 
> I'm wondering if we have the same replacement for x86@kernel.org which 
> I've received multiple bounces from (not sure if it currently is or not, I 
> haven't tried because of that recently) or things like security@kernel.org 
> or trivial@kernel.org.

security@ will remain as-is, when it gets back up and working.  I don't
know about trivial@, I wasn't aware of that one.  The mailman stuff for
kernel.org is pretty far down the list of priority of what is being
worked on.

greg k-h
