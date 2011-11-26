Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab1KZPTe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 10:19:34 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50717 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752767Ab1KZPT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 10:19:26 -0500
X-Sasl-enc: J4d8KlP9sE0+jlYctLbg+MmdMwBShaysN0r9nY2GwJS/ 1322320765
Date: Sat, 26 Nov 2011 07:10:13 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, linux-kernel@vger.kernel.org
Subject: Fix build breakage in your tree in the drivers/staging/iio directory
Message-ID: <20111126151013.GA16446@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, can you please revert b46413367961c2e8bd827e067a231be982aaeee2 in
your tree?  It breaks the build and didn't seem to be tested by Al.

I'll prepare a fix for this based on Al's patch, that doesn't break
things and send it to you later next week (I'm about to jump on a plane
for Tokyo in a few hours and can't test one at the moment), but for now,
this should be reverted as I'm getting lots of emails about it.

thanks,

greg k-h
