Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab2F1Tjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 15:39:40 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60288 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab2F1Tjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 15:39:39 -0400
From: "Matt Renzelmann" <mjr@cs.wisc.edu>
To: "'Dan Carpenter'" <dan.carpenter@oracle.com>,
        "'Bryan Wu'" <bryan.wu@canonical.com>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>, <linux-leds@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        "'Matt Renzelmann'" <mjr@cs.wisc.edu>
References: <20120627085800.GA3007@mwanda> <20120627091055.GW31212@elgon.mountain> <CAK5ve-J9CgB=uz-09=POPoygWvNs7k_R3tbZVAzi0VLKTpvOqA@mail.gmail.com> <20120627105547.GD3007@mwanda>
In-Reply-To: <20120627105547.GD3007@mwanda>
Subject: RE: [patch -resend] leds-lp5523: BUG() in error handling in probe()
Date: Thu, 28 Jun 2012 14:39:38 -0500
Message-ID: <00ba01cd5565$c4848750$4d8d95f0$@cs.wisc.edu>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQGYAGsaJKYCFUseoqCKAlVXXRtleQJ+7wRBAO4j9koCFBMigpdOvqGg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > Just be curious, what's kind of the tool here?
> >
> 
> Sorry I should have CC'd Matt on this.  I think it's something he
> is working on at the University of Wisconsin.  That's all I know.
> 
> regards,
> dan carpenter
> 
> > -Bryan

Dan is correct.  We've submitted the project for publication but whether it will
be accepted is another question.  If it's published I'd be happy to provide a
reference.

In a nutshell, the tool we've developed uses symbolic execution to reduce the
need for device hardware for driver testing and execute real Linux drivers in
the kernel.  It provides symbolic data in place of hardware input.  The tool
allows us to run real drivers even if the hardware is unavailable.  It can't
find all bugs, but it can find many that could manifest in real conditions, e.g.
null pointer dereferences, incorrect kernel API usage, some "panics" and "BUG"
calls, etc.

I'll try to remember to write back when it's published, at which point I'd be
happy to provide more detail.

Thanks for the interest,
Matt

