Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab1HWKQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 06:16:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216Ab1HWKQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 06:16:23 -0400
Date: Tue, 23 Aug 2011 12:16:01 +0200
From: Karel Zak <kzak@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, util-linux@vger.kernel.org
Subject: Re: [PATCH] setarch: Add --uname-2.6 option for personality flag
	UNAME26
Message-ID: <20110823101601.GA23745@nb.net.home>
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org> <1314079201.12047.68.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314079201.12047.68.camel@deadeye>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 07:00:01AM +0100, Ben Hutchings wrote:
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> On Fri, 2011-08-19 at 16:15 -0700, Andi Kleen wrote:
> [...]
> > To use:
> > 
> > wget ftp://ftp.kernel.org/pub/linux/kernel/people/ak/uname26/uname26.c
> > gcc -o uname26 uname26.c
> > ./uname26 program
> [...]
> 
> I would suggest adding this to setarch, as that handles all the other
> personality flags.  The following patch to util-linux seems to do the
> trick.

 I have one simple rule: "Linus' tree first", and I don't see UNAME26
 in include/linux/personality.h ...

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
