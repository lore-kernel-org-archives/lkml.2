Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101Ab1JRBhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 21:37:55 -0400
Received: from smtp-out.google.com ([74.125.121.67]:43493 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757092Ab1JRBhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 21:37:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=bM6DALgXaffJAIScknJ+KdrQFMndoKQBtiOBjqksU1RYSfAJ7+JPrZ9/s2VwkBe8L
	HLWEOOO9V0iqVEfeuuRVg==
Date: Mon, 17 Oct 2011 18:37:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Josh Boyer <jwboyer@redhat.com>
cc: Greg Kroah-Hartman <greg@kroah.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] Update email address for stable patch submission
In-Reply-To: <20111018013320.GR1165@zod.bos.redhat.com>
Message-ID: <alpine.DEB.2.00.1110171833470.13515@chino.kir.corp.google.com>
References: <20111018011638.GQ1165@zod.bos.redhat.com> <alpine.DEB.2.00.1110171826450.13515@chino.kir.corp.google.com> <20111018013320.GR1165@zod.bos.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011, Josh Boyer wrote:

> > Hmm, is stable@vger.kernel.org a replacement for stable@kernel.org or is 
> > it just temporary until kernel.org is fully back to life?
> 
> To my understanding, stable@kernel.org is now just a forward to
> stable@vger.kernel.org.

Right, but the question is whether that's temporary or permanent.

> Personally, I'd rather see the vger list take over entirely.  However,
> that decision will remain in the more than capable hands of the admins.
> 

I'm wondering if we have the same replacement for x86@kernel.org which 
I've received multiple bounces from (not sure if it currently is or not, I 
haven't tried because of that recently) or things like security@kernel.org 
or trivial@kernel.org.
