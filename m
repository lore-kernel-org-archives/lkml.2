Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab1GBRF5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 13:05:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34338 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab1GBRFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 13:05:55 -0400
Date: Sat, 2 Jul 2011 19:05:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andi Kleen <andi@firstfloor.org>, Alan Stern <stern@rowland.harvard.edu>,
        Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk, rjw@sisk.pl,
        linux-usb@vger.kernel.org
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Message-ID: <20110702170554.GJ23059@one.firstfloor.org>
References: <1309554818.2722.48.camel@mulgrave> <Pine.LNX.4.44L0.1107012200260.4273-100000@netrider.rowland.org> <20110702060846.GH23059@one.firstfloor.org> <1309609482.2554.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309609482.2554.8.camel@mulgrave>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Which goes from the device unplug to the oops.  However, there are puts
> missing from this; particularly the one where the reference goes to
> zero.

The count was always one off because it dumps it before the actual
put.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
