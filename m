Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab1JXOAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 10:00:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932692Ab1JXN77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 09:59:59 -0400
Date: Mon, 24 Oct 2011 09:58:47 -0400
From: Dave Jones <davej@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] module,bug: Add TAINT_OOT_MODULE flag for modules not
 built in-tree
Message-ID: <20111024135847.GA26102@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
	Debian kernel maintainers <debian-kernel@lists.debian.org>,
	Rusty Russell <rusty@rustcorp.com.au>
References: <1319461948.31243.31.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319461948.31243.31.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 03:12:28PM +0200, Ben Hutchings wrote:
 > Use of the GPL or a compatible licence doesn't necessarily make the code
 > any good.  We already consider staging modules to be suspect, and this
 > should also be true for out-of-tree modules which may receive very
 > little review.
 > 
 > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
 > ---
 > Debian has been carrying this for the last few kernel versions.  The
 > recent thread '[RFC] virtualbox tainting.' and discussions at KS suggest
 > that this might be more generally useful.

Looks good to me.

Reviewed-by: Dave Jones <davej@redhat.com>

