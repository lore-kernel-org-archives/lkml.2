Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab2A3W2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:28:39 -0500
Received: from [206.117.179.246] ([206.117.179.246]:54535 "EHLO labridge.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752554Ab2A3W2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:28:36 -0500
Message-ID: <1327962498.25132.60.camel@joe2Laptop>
Subject: Re: [RFC PATCH] telephony: Move to staging
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Date: Mon, 30 Jan 2012 14:28:18 -0800
In-Reply-To: <20120130221838.GA5904@suse.de>
References: <cd8d3ef8b646dc0b1c451e61c57d639cadbc7c21.1327961290.git.joe@perches.com>
	 <20120130221838.GA5904@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 14:18 -0800, Greg KH wrote:
> On Mon, Jan 30, 2012 at 02:11:34PM -0800, Joe Perches wrote:
> > This stuff is really old and in quite poor shape.
> > Does anyone still use it?
> > 
> > If not, I think it's appropriate to let it simmer
> > in staging for a few releases.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> Is this really unmaintained?

No listed MAINTAINER, nothing but drive-by
cleanups in git history.

The company quicknet.net seems out of business.
Its website is dead since 2004 according to wayback.

Some of these cards are on ebay right now
but I don't know if asterisk or any other
VOIP software still supports this stuff.

> Fine with me, but you need a message/TODO file that says if someone
> needs/wants it, to ask you, and it will be moved back.
> 
> Care to add that to the patch and resend it?

OK.

