Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab0JQStN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 14:49:13 -0400
Received: from canuck.infradead.org ([134.117.69.58]:41857 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521Ab0JQStM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 14:49:12 -0400
Date: Sun, 17 Oct 2010 14:49:11 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>,
        warthog9@kernel.org, hpa@zytor.com, devel@lists.fedoraprojet.org
Subject: Re: ima: use of radix tree cache indexing == massive waste of memory?
Message-ID: <20101017184911.GC28060@infradead.org>
References: <20101016065206.GO4681@dastard>
 <20101016192027.GA6883@infradead.org>
 <1287295077.3020.83.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287295077.3020.83.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 01:57:57AM -0400, Mimi Zohar wrote:
> As for using a radix tree, that was what you recommended.

I told you guys to use a separate tree exactly to avoid wasting
ressources if people don't use IMA.  You guys back then promised
you would not ever turn it on in distros nad just use if for research.

Fact is you pressured distributions to turn it on now, and you fucked
up the requirement to not have any impact if enabled bu not used.

After fixing that mess it should be a lesson to not take more of this
crap that no one is going to use anywya.

