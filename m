Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab1ITQV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:21:57 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:51661 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752588Ab1ITQVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:21:54 -0400
X-Sasl-enc: KbgEF1ZOSEOlAwYQAY+c8/14Sa1cxZ0aDZ7ylL51djqr 1316535531
Date: Tue, 20 Sep 2011 09:17:43 -0700
From: Greg KH <gregkh@suse.de>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        greg@kroah.com
Subject: [patch 0/8] Samsung Laptop driver patches - resend
Message-ID: <20110920161743.GA32737@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

Here is a resend of the samsung-laptop patches, with the correct
authorship info in it.  Sorry about the last batch, 'quilt mail' strips
them off when sending them out, despite the information being in the
original patch.

The patches are against Linus's current tree, but should apply just fine
to linux-next as well.

If there are any problems with them, please let me know.

Oh, and if anyone wants to take over maintainership of this driver,
please let me know.  I no longer have the hardware to be able to test
any changes for it, which is why this took so long to get pushed out to
you.

thanks,

greg k-h

