Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab1GHRnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 13:43:49 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34537 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab1GHRns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 13:43:48 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 8 Jul 2011 19:43:35 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <greg@kroah.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: 3.0-rc6: USB khubd deadlock when hub is powered down
Message-ID: <20110708194335.28692424@stein>
In-Reply-To: <Pine.LNX.4.44L0.1107081005080.2208-100000@iolanthe.rowland.org>
References: <20110707235647.13264b8a@stein>
	<Pine.LNX.4.44L0.1107081005080.2208-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 08 Alan Stern wrote:
> In general, adding support for USB-3.0 has been a tremendous job (of 
> which Sarah has done the lion's share of the work), involving not just 
> adding a new driver but also making significant changes to the 
> subsystem core.  Those changes have been sufficiently complicated that 
> things haven't settled down yet.
> 
> Particularly since it has now become clear that a key implementation
> decision (to allocate periodic bandwidth dynamically, as it is used,
> rather than statically) needs to be reversed.  The fan-out effects from
> this will require changes to several other drivers as well, and this is 
> all still in the design stage.  Thus, we are forced to limp along with 
> a hacky, not-entirely-correct implementation until everything can be 
> put right.  I don't expect this to happen quickly.

OK, fair enough.  I acknowledge that such a scope expansion at all layers
of the subsystem is a difficult undertaking.  Plus, you had working
patches that addressed my issue, even before I got around to report it.
-- 
Stefan Richter
-=====-==-== -=== -=---
http://arcgraph.de/sr/
