Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab1JZXoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 19:44:11 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54671 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753398Ab1JZXoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 19:44:09 -0400
Message-ID: <1319672648.21924.26.camel@Joe-Laptop>
Subject: Re: [PATCH] checkpatch: improve error message for p1-check
From: Joe Perches <joe@perches.com>
To: David Rientjes <rientjes@google.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, Andy Whitcroft <apw@canonical.com>
Date: Wed, 26 Oct 2011 16:44:08 -0700
In-Reply-To: <alpine.DEB.2.00.1110261633190.19579@chino.kir.corp.google.com>
References: <1319027583-17842-1-git-send-email-w.sang@pengutronix.de>
	 <alpine.DEB.2.00.1110261329240.23111@chino.kir.corp.google.com>
	 <1319669467.21924.18.camel@Joe-Laptop>
	 <alpine.DEB.2.00.1110261607150.6982@chino.kir.corp.google.com>
	 <1319670886.21924.22.camel@Joe-Laptop>
	 <alpine.DEB.2.00.1110261633190.19579@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-26 at 16:34 -0700, David Rientjes wrote:
> On Wed, 26 Oct 2011, Joe Perches wrote:
> > > So we need a combination of the two approaches then, it makes sense to 
> > > only emit the warning if the patched file exists in both prefixes.
> > I don't think so.  What about something like:
> > $ diff -urN kernel/foo~ kernel/foo > patch
> > I think we should only care about the patched file,.
> I mean it only makes sense if both prefixes exist (otherwise patch and 
> git-apply will assume it's not a -p0 patch).

I think we should not care about the prefixes at all,
only whether or not the patched file exists.


