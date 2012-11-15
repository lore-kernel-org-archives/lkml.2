Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423599Ab2KOJdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 04:33:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59254 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423157Ab2KOJdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 04:33:51 -0500
Date: Thu, 15 Nov 2012 10:33:47 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/14] Win 8 support for digitizers
In-Reply-To: <20121114200141.GA15074@polaris.bitmath.org>
Message-ID: <alpine.LNX.2.00.1211151033070.15877@pobox.suse.cz>
References: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com> <20121114200141.GA15074@polaris.bitmath.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012, Henrik Rydberg wrote:

> > * patches 1-9 has already been reviewed and are ready for inclusion I would say.
> > * Jiri, I kept your ack on patch 4 even if I changed the place of the comment in hid.h
> > * patch 10 is half new as it is splitted from a patch of the v3
> > * patch 11 has been changed according to Henrik's comments
> > * patches 12-13 have been splitted since v3 to introduce QUIRK_HOVERING and setup WIN 8
> > devices in a better way.
> > * patch 14 has been copied from the v3 as Dmitry wanted to use a MSC event for the timestamp.
> 
> Everything but the last patch looks good now, me thinks. Thanks!

I have now applied everything (with all the gathered Acks/Reviewed-by 
incorporated) but the patch #14.

Thanks,

-- 
Jiri Kosina
SUSE Labs
