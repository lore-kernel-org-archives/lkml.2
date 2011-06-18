Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab1FRRcX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 13:32:23 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:60778 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab1FRRcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 13:32:21 -0400
Date: Sat, 18 Jun 2011 13:32:14 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, hughd@google.com,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] TMPFS: Expand "help" to explain value of
 TMPFS_POSIX_ACL
In-Reply-To: <20110618192847.62dc6d87@stein>
Message-ID: <alpine.DEB.2.02.1106181331490.5909@localhost6.localdomain6>
References: <alpine.DEB.2.02.1106180743040.17576@localhost6.localdomain6> <20110618192847.62dc6d87@stein>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Jun 2011, Stefan Richter wrote:

> On Jun 18 Robert P. J. Day wrote:
> > +	  If you've selected TMPFS, you almost certainly want this option
> > +	  as well since a number of user space features (ie., ALSA sound)
> > +	  require POSIX ACL support under /dev to work properly.  In other
>
> There are still many systems which do not use ACLs in /dev or anywhere
> else at all.  Hence, "may require POSIX ACL support".
>
> > +	  words, if you're not sure and you have no *compelling* reason to
> > +	  deselect this feature, say Y.
>
> The asterisks around compelling are unnecessary.

  ok, i can reword and resubmit if you like.

rday

-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
