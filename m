Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab2IZR4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:56:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60659 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757657Ab2IZR4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:56:10 -0400
Date: Wed, 26 Sep 2012 10:56:06 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: devel@linuxdriverproject.org
Cc: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: staging tree closed for 3.7
Message-ID: <20120926175606.GA10762@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With 3.6 about to be released, I've now closed the 3.7 staging-next tree
for new features / cleanups.  It's bug-fixes only now until 3.7-rc1 is
out.

Ian and Hartley, I've not applied a few of the last patches you sent me
as it seems there was some disagreements.

Also, the recent __user cleanups for the comedi drivers seemed to be way
too big.  I'll take a look at them in the next few weeks, surely we can
do this in a simpler manner without needing to get every driver
involved, but I could be wrong.  I'll let you all know.

The diffstat for the 3.7 merge is pretty big:
 660 files changed, 50816 insertions(+), 24515 deletions(-)
with 1086 individual patches, which is quite a lot.

thanks,

greg k-h
