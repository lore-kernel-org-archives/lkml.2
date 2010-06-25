Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab0FYRp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 13:45:27 -0400
Received: from smtp-out.google.com ([74.125.121.35]:54387 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab0FYRpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 13:45:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=hF88rufkRBZoT2xRrbta0g2BLoj/aIaa6QpLgN6+tyP+Ml4cYOFV8ciiPTlL15uZY
	YtTzxilATZJ67x+bxXwRQ==
MIME-Version: 1.0
In-Reply-To: <4C2231B5.10401@athenacr.com>
References: <AANLkTimxGK93hnV9-jGZAeeJ_JnrWCTaq-dkDvfUW6St@mail.gmail.com>
	<06r8f7-jsn.ln1@chipmunk.wormnet.eu>
	<4C2231B5.10401@athenacr.com>
Date: Fri, 25 Jun 2010 10:39:26 -0700
Message-ID: <AANLkTikKKoS6YPWmIuNAdFIOhXi6d3qIf-Nsci3UaCGN@mail.gmail.com>
Subject: Re: SO_REUSEPORT
From: Tom Herbert <therbert@google.com>
To: Brian Bloniarz <bmb@athenacr.com>
Cc: Alexander Clouter <alex@digriz.org.uk>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Of course this depends on what you are doing, but my opinion is that the
>> functionality has been unneeded so far by people in the kernel, so *I*
>> must be doing something wrong ;)
>
> Tom Herbert gave a pretty great description of why you
> might want this functionality in his original patch submission:
>
> http://kerneltrap.org/mailarchive/linux-netdev/2010/4/19/6274993
>
> If you follow that thread though, there wasn't consensus about
> the best architecture & API for it, and nothing has made it
> yet.
>
I am planning to get back to this as the patch still needs some work
and isn't quite robust or optimized yet.  Some restructuring is needed
in the socket hash lists.  The UDP implementation in the patch will
work okay, and the TCP works as long as the number of listeners isn't
changing.
