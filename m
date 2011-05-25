Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab1EYXxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 19:53:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19559 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757175Ab1EYXxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 19:53:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=TUwmm4enMavFUPlhr6TG7NwsuyRYgOH7WVZoSX0atTp3XFfj6v/93D+NsGtKOSQ0AR
         gppWTC7jBwo8TMMzAHXg==
Date: Wed, 25 May 2011 16:53:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jens Axboe <jaxboe@fusionio.com>
cc: Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: SLUB regression in current Linus
In-Reply-To: <4DDCF947.2020505@fusionio.com>
Message-ID: <alpine.DEB.2.00.1105251652230.29729@chino.kir.corp.google.com>
References: <alpine.LRH.2.00.1105242146240.12134@tundra.namei.org> <20110525074040.GA9233@elte.hu> <4DDCF947.2020505@fusionio.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Jens Axboe wrote:

> >> I started experiencing a boot hang in 2.6.39+, and bisected it to this 
> >> change:
> > 
> > i too was seeing various instabilities and SLUB corruption in -tip testing. 
> > Every 5th randconfig kernel crashes.
> > 
> > I started testing the revert.
> 
> My test machine insta-crashes on boot. Lets please get this reverted.
> 

Linus merged a71ae47a2cbf ("slub: Fix double bit unlock in debug mode") 
that should fix the issue.
