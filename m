Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab0DPGoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 02:44:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57083
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754568Ab0DPGoX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 02:44:23 -0400
Date: Thu, 15 Apr 2010 23:44:26 -0700 (PDT)
Message-Id: <20100415.234426.29003225.davem@davemloft.net>
To: agimenez@sysvalve.es
Cc: dgiagio@gmail.com, dborca@yahoo.com, James.Bottomley@HansenPartnership.com,
       ralf@linux-mips.org, gregkh@suse.de, jonas.sjoquist@ericsson.com,
       torgny.johansson@gmail.com, steve.glendinning@smsc.com,
       dbrownell@users.sourceforge.net, omar.oberthur@gmail.com,
       remi.denis-courmont@nokia.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH Resubmission v2] drivers/net/usb: Add new driver ipheth
From: David Miller <davem@davemloft.net>
In-Reply-To: <1271360791-30312-1-git-send-email-agimenez@sysvalve.es>
References: <1269984864-28159-1-git-send-email-agimenez@sysvalve.es>
	<1271360791-30312-1-git-send-email-agimenez@sysvalve.es>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: L. Alberto Giménez <agimenez@sysvalve.es>
Date: Thu, 15 Apr 2010 21:46:29 +0200

> From: dborca@yahoo.com
> 
> Add new driver to use tethering with an iPhone device. After initial submission,
> apply fixes to fit the new driver into the kernel standards.
> 
> There are still a couple of minor (almost cosmetic-level) issues, but the driver
> is fully functional right now.
> 
> Signed-off-by: L. Alberto Giménez <agimenez@sysvalve.es>

I'm very confused about the authorship of this driver.

Who wrote it?

You added a "From: " line using specifying Daniel Borca (btw,
when you add these "From: " lines you  need to specify it in
the form "From: NAME <EMAIL>" not just "From: EMAIL" so in
this case we want to see "From: Daniel Borca <dborca@yahoo.com>")

The code itself gives copyright to Diego Giagio <diego@giagio.com>
and he is also the one listed in the MODULE_AUTHOR().

And you're the one submitting the code, and also the only person
actually giving a signoff in the commit message.

It's too confusing and ambiguous, and if there are any problems
down the road the last thing we need is for the authorship to
be ambiguous.

I would really appreciate it if the authorship was clearly stated, and
the actual author of the code actually gives a "Signed-off-by: " line
in the commit message for this inclusions of this driver.

Please fix this up and resubmit, thank you.

Thanks.
