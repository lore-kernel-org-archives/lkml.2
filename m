Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab1GBRG5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 13:06:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34350 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab1GBRGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 13:06:53 -0400
Date: Sat, 2 Jul 2011 19:06:52 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <andi@firstfloor.org>, Alan Stern <stern@rowland.harvard.edu>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk,
        linux-usb@vger.kernel.org
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Message-ID: <20110702170652.GK23059@one.firstfloor.org>
References: <1309554818.2722.48.camel@mulgrave> <Pine.LNX.4.44L0.1107012200260.4273-100000@netrider.rowland.org> <20110702060846.GH23059@one.firstfloor.org> <201107021448.22616.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107021448.22616.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 02, 2011 at 02:48:22PM +0200, Rafael J. Wysocki wrote:
> On Saturday, July 02, 2011, Andi Kleen wrote:
> > > I'm not able to reproduce it on a vanilla 3.0-rc5 system.  Can anybody
> > > give the exact sequence of steps you went through to trigger the bug?
> > 
> > Connect USB storage device with builtin fake CD rom. Wait for udisk
> > to mount it. Pull cable. udisk does umount. Oops.
> > 
> > I also got a log of the refcounting now if you want it.
> 
> Does reverting commit e1866b33b1e89f077b7132daae3dfd9a594e9a1a help?

I'll try next week.

-Andi
