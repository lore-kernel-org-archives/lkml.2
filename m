Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab2DRR2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 13:28:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab2DRR2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 13:28:45 -0400
Date: Wed, 18 Apr 2012 19:28:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Matthew Garrett <mjg@redhat.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Bastien Nocera <hadess@hadess.net>,
        Jeremy Fitzhardinge <jeremy@goop.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org,
        Richard Hughes <richard@hughsie.com>
Subject: Re: [PATCH] HID: hid-input: default HID_BATTERY_STRENGTH to no
In-Reply-To: <20120418142450.GA30083@srcf.ucam.org>
Message-ID: <alpine.LNX.2.00.1204181926340.16373@pobox.suse.cz>
References: <20120418140517.GM19507@zod.bos.redhat.com> <1334758134.8818.132.camel@novo.hadess.net> <20120418141131.GN19507@zod.bos.redhat.com> <20120418142450.GA30083@srcf.ucam.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2012, Matthew Garrett wrote:

> > Matthew suggested that additional kernel patches were required to add a
> > scope parameter so upower could understand that the battery is powering
> > a device and not the system.
> > 
> > Also, when did it become OK to force-enable a new feature that is
> > _known_ to not work properly on recent userspace?  That makes no sense
> > to me.
> 
> I agree. It's a great feature, but it shouldn't be default y if 
> userspace isn't ready for it yet.

Fully agreed, the 'default y' part escaped my attention. I will be 
applying the patch and pushing out to Linus.

I even wonder whether we shouldn't put a warning into the Kconfig entry, 
explaining the consequences of having userspace not ready for the feature.

-- 
Jiri Kosina
SUSE Labs
