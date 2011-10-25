Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab1JYQwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 12:52:00 -0400
Received: from mail.elliptictech.com ([209.217.122.41]:55985 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab1JYQv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 12:51:59 -0400
Date: Tue, 25 Oct 2011 12:51:42 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Greg KH <greg@kroah.com>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Subject: Re: [PATCH] module,bug: Add TAINT_OOT_MODULE flag for modules not
 built in-tree
Message-ID: <20111025165142.GA25354@elliptictech.com>
References: <1319461948.31243.31.camel@deadeye>
 <4EA57CBF.2050901@xenotime.net>
 <87k47tpvvm.fsf@rustcorp.com.au>
 <20111025153855.GA24779@elliptictech.com>
 <1319558749.11727.6.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319558749.11727.6.camel@deadeye>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-25 18:05 +0200, Ben Hutchings wrote:
> On Tue, 2011-10-25 at 11:38 -0400, Nick Bowler wrote:
> > This patch prevents the use of lockdep for debugging out of tree
> > modules, which is rather mean.
> 
> It was already disabled for staging modules, which seems equally
> unhelpful.

This is not the case: lockdep works fine with staging modules.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
