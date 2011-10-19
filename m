Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab1JSQTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 12:19:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54621 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab1JSQTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 12:19:22 -0400
Subject: Re: Patch Upstream: cputimer: Cure lock inversion
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Greg KH <greg@kroah.com>, Dave Jones <davej@redhat.com>,
        Simon Kirby <sim@hostway.ca>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <CA+5PVA6GnscQTRbv=r0NZvU4jNGwnr64OG6qAZvGhnjSAGCgrA@mail.gmail.com>
References: <20111019153914.9153A2188@git.kroah.org>
	 <20111019154910.GA9361@kroah.com>
	 <CA+5PVA7-9Vyy+16+wXPCPEce3v4z8PxwW3WfGGBDzobAC-_-bQ@mail.gmail.com>
	 <20111019160037.GA11087@kroah.com>
	 <CA+5PVA6GnscQTRbv=r0NZvU4jNGwnr64OG6qAZvGhnjSAGCgrA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Oct 2011 18:19:16 +0200
Message-ID: <1319041156.2593.1.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-19 at 12:03 -0400, Josh Boyer wrote:
> > Ugh, I'll go dig, but help would be appreciated...
> 
> My guess is they meant d670ec13178d0fd868
> 
Your guess is right, no idea how I messed that up, my git tree contains
both commits and they're similar but different version of the same
patch.

:-(

