Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab2DROMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:12:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab2DROMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:12:01 -0400
Date: Wed, 18 Apr 2012 10:11:31 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Bastien Nocera <hadess@hadess.net>
Cc: Jiri Kosina <jkosina@suse.cz>, Jeremy Fitzhardinge <jeremy@goop.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org, Richard Hughes <richard@hughsie.com>,
        mjg@redhat.com
Subject: Re: [PATCH] HID: hid-input: default HID_BATTERY_STRENGTH to no
Message-ID: <20120418141131.GN19507@zod.bos.redhat.com>
References: <20120418140517.GM19507@zod.bos.redhat.com>
 <1334758134.8818.132.camel@novo.hadess.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334758134.8818.132.camel@novo.hadess.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 03:08:54PM +0100, Bastien Nocera wrote:
> On Wed, 2012-04-18 at 10:05 -0400, Josh Boyer wrote:
> > Commit 4f5ca836b "HID: hid-input: add support for HID devices reporting
> > Battery Strength" added the CONFIG_HID_BATTERY_STRENGTH option to report
> > the battery strength of HID devices.  The commit log explicitly mentions
> > it not working properly with recent userspace, but it is default y
> > anyway.  This is rather odd, and actually causes problems on real
> > systems.
> > 
> > This works around Fedora bug
> > https://bugzilla.redhat.com/show_bug.cgi?id=806295
> 
> Don't. The only bit of user-space that's broken is upower, and it's
> getting a fixed release shortly.

Matthew suggested that additional kernel patches were required to add a
scope parameter so upower could understand that the battery is powering
a device and not the system.

Also, when did it become OK to force-enable a new feature that is
_known_ to not work properly on recent userspace?  That makes no sense
to me.

josh
