Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab2FXUrb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 16:47:31 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28292 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab2FXUra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 16:47:30 -0400
Date: Sun, 24 Jun 2012 23:47:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Forest Bond <forest@alittletooquiet.net>,
        Marcos Paulo de Souza <marcos.mage@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6656: Style cleanup of iwctl
Message-ID: <20120624204711.GK5390@mwanda>
References: <alpine.LNX.2.00.1206242131040.30361@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1206242131040.30361@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2012 at 09:45:58PM +0200, Jesper Juhl wrote:
> Clean up the files iwctl.c and iwctl.h to match the official
> CodingStyle a bit more closely.
> 
> This is *not* a complete cleanup, but it brings the files quite close
> to the accepted style compared to the state they were originally in
> (which was a complete mess IMHO).
> 
> It's mostly just whitespace changes, but there are also a few
> pointless casts that were removed, a few tiny reshuffelings of code to
> reduce indentation etc, but nothing major. There are no functional
> changes.
> 
> I could have split this in multiple patches, I guess, but then I'd
> probably have ended up with a bunch of patches all touching the same
> lines multiple times in order to make multiple different changes and
> that didn't seem worth it.  I opted to just do the whole thing in one
> big patch, then we at least have a sane base upon which to apply
> future smaller cleanups.

Nope.  It is worth it.  Broken out patches are a million times
easier to review.

It frustrates me that you would do things like this when you know
the rules.  Which part is difficult to understand?

regards,
dan carpenter

