Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381Ab1GHNlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 09:41:25 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33276 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab1GHNlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 09:41:23 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 8 Jul 2011 15:41:13 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: <linux-scsi@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, axboe@kernel.dk,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andi Kleen <andi@firstfloor.org>, Dave Jones <davej@redhat.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Message-ID: <20110708154113.3347eef0@stein>
In-Reply-To: <20110708153742.17121fa8@stein>
References: <1309609482.2554.8.camel@mulgrave>
	<Pine.LNX.4.44L0.1107021320180.14703-100000@netrider.rowland.org>
	<20110703223757.0e2b5ee0@stein>
	<20110708153742.17121fa8@stein>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 08 Stefan Richter wrote:
> But today I did get the following crash on 3.0-rc6-71-g4dd1b49 x86-64 plus
> Alan's "USB: additional regression fix for device removal" when I powered
> down an USB hub with an empty USB card reader attached (or when I powered
> it up, impossible for me to say):

Judging from the missing hours in an application log, it happened at
power down of the hub = at removal of the card reader.
-- 
Stefan Richter
-=====-==-== -=== -=---
http://arcgraph.de/sr/
