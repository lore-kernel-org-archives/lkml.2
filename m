Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab1IZOrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 10:47:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48112 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab1IZOrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 10:47:04 -0400
Date: Mon, 26 Sep 2011 16:47:00 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] autodetection of multitouch devices
In-Reply-To: <20110926144635.GA6921@polaris.bitmath.org>
Message-ID: <alpine.LNX.2.00.1109261644250.24692@pobox.suse.cz>
References: <1316617015-11648-1-git-send-email-benjamin.tissoires@gmail.com> <alpine.LNX.2.00.1109261419330.13109@pobox.suse.cz> <20110926144635.GA6921@polaris.bitmath.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Sep 2011, Henrik Rydberg wrote:

> > > These two patches finally enable the kernel to handle multitouch devices correctly.
> > > If a device presents in its report descriptors the usage Contact ID, then it is considered as
> > > a multitouch device and handled by hid-multitouch.
> > 
> > Hi Banjamin,
> > 
> > thanks a lot for working on this. I have now queued the patches in my 
> > tree.
> 
> Hi Benjamin,
> 
> Late as it seems, here are a couple of questions:
> 
> 1. How was this tested? By removing all white-listed devices in
> hid-multitouch.c to see if the usual suspects are still picked up?

If we didn't have full test coverage (which I suppose to be the case), we 
can still revert to the old method after the merge window if there reports 
that this broke things on particular devices.

Do you guys at least have report descriptor dumps from most of the 
supported devices?

Thanks,

-- 
Jiri Kosina
SUSE Labs
