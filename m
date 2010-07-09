Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab0GIR35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 13:29:57 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:47292 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755994Ab0GIR3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 13:29:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=nQMJWpPNnZ8L0QGZjZjnJ1Mg3lrg1yf9pJeLBqxJlvvMpelVHXhNZICjnwwYB/8F136MRy8/WOEPAzlh8m+a6tuzXxZ29jS0GeaCwfjpL9IeEGc/coYVCoSBm7qG9XsE;
Date: Fri, 9 Jul 2010 10:29:35 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Nico Schottelius <nico-linux-20100709@schottelius.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35-rc4 / X201 issues
Message-ID: <20100709102935.60648095@virtuousgeek.org>
In-Reply-To: <20100709170432.GA7691@schottelius.org>
References: <20100709170432.GA7691@schottelius.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jul 2010 19:04:32 +0200
Nico Schottelius <nico-linux-20100709@schottelius.org> wrote:

> Good evening hackers,
> 
> latest report from 2.6.35-rc4 on X201:
> 
>   - (almost) everytime I close and reopen the lid, the image is screwed up
>     - switching to vt1 (away from xorg) and back to vt7 fixes that almost always
>     - did not happen on 2.6.34 (iirc)

Can you bisect this issue?

>   - if it's not screwed up, the system is frozen
>     - does not react on ping, last image is displayed, no keyboard shortcut works
>     - ATTENTION: it's *NOT* needed to suspend directly before to get a freeze!
>       - simplying closing & opening the lid is enough

Presumably this used to work too, so a bisect might help here as well.

FWIW mine doesn't behave this way; I have an x201s and it works pretty
well with current bits (note that a bunch of 2D, Mesa and libdrm fixes
have landed recently as well).

-- 
Jesse Barnes, Intel Open Source Technology Center
