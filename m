Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab1FPKDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 06:03:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34433 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757548Ab1FPKDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 06:03:39 -0400
Date: Thu, 16 Jun 2011 12:03:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Greg KH <gregkh@suse.de>
Cc: =?ISO-8859-15?Q?Ortwin_Gl=FCck?= <odi@odi.ch>,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.39.1 input regression
In-Reply-To: <20110615150326.GA7128@suse.de>
Message-ID: <alpine.LRH.2.00.1106161201500.11562@twin.jikos.cz>
References: <4DF85C5F.4080307@odi.ch> <20110615150326.GA7128@suse.de>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jun 2011, Greg KH wrote:

> > This patch in 2.6.39.1 breaks magicmouse support for me completely.
> > a5ccaac64c17ce3cc1878a6d479a6f1b16092c24
> > HID: magicmouse: ignore 'ivalid report id' while switching modes
> > 
> > The device will no longer work at all:
> > magicmouse 0005:05AC:030D.0005: input,hidraw2: BLUETOOTH HID v0.84 Mouse
> > [gandalf mouse] on 7C:6D:62:9F:DB:2D
> > magicmouse 0005:05AC:030D.0005: unable to request touch data (2)
> > 
> > Fine in previous kernels.
> 
> This has been discussed already, and it should be fixed in Linus's tree
> right now, right?

It's not yet -- apparently the symptoms aer different for different 
people, probably because of differences in firmware.

Plus one of the testers is now quite busy, so the turnaround was rather 
slow.

I already have patch in my tree that should cover all the cases. Will be 
sending pull request to Linus likely today.

> If so, can someone please send stable@kernel.org the proper fix for 
> this?

Yes, I will then send the patch stable-way as well.

-- 
Jiri Kosina
SUSE Labs

