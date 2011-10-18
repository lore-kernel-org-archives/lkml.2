Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab1JRFsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 01:48:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39293 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab1JRFsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 01:48:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=SjL4BO0QjGyVUHNYT4THEUD17VcgNH/J5xCHJYLyGSGQ691D92clxDQz2vTw7A6OO
	LP/uLOqbEw2AQ9IbLZNyA==
Date: Mon, 17 Oct 2011 22:47:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg KH <greg@kroah.com>
cc: Josh Boyer <jwboyer@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Update email address for stable patch submission
In-Reply-To: <20111018025402.GA6475@kroah.com>
Message-ID: <alpine.DEB.2.00.1110172242240.4880@chino.kir.corp.google.com>
References: <20111018011638.GQ1165@zod.bos.redhat.com> <alpine.DEB.2.00.1110171826450.13515@chino.kir.corp.google.com> <20111018013320.GR1165@zod.bos.redhat.com> <alpine.DEB.2.00.1110171833470.13515@chino.kir.corp.google.com>
 <20111018025402.GA6475@kroah.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011, Greg KH wrote:

> > > To my understanding, stable@kernel.org is now just a forward to
> > > stable@vger.kernel.org.
> > 
> > Right, but the question is whether that's temporary or permanent.
> 
> Permanent.
> 

Ok, thanks for the clarification, that means Josh's patch is the absolute 
right thing to do.

Acked-by: David Rientjes <rientjes@google.com>
