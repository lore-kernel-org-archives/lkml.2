Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab2DROZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:25:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57243 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab2DROZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:25:06 -0400
Date: Wed, 18 Apr 2012 15:24:50 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Bastien Nocera <hadess@hadess.net>, Jiri Kosina <jkosina@suse.cz>,
        Jeremy Fitzhardinge <jeremy@goop.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org,
        Richard Hughes <richard@hughsie.com>
Subject: Re: [PATCH] HID: hid-input: default HID_BATTERY_STRENGTH to no
Message-ID: <20120418142450.GA30083@srcf.ucam.org>
References: <20120418140517.GM19507@zod.bos.redhat.com>
 <1334758134.8818.132.camel@novo.hadess.net>
 <20120418141131.GN19507@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120418141131.GN19507@zod.bos.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 10:11:31AM -0400, Josh Boyer wrote:
> On Wed, Apr 18, 2012 at 03:08:54PM +0100, Bastien Nocera wrote:
> > Don't. The only bit of user-space that's broken is upower, and it's
> > getting a fixed release shortly.
> 
> Matthew suggested that additional kernel patches were required to add a
> scope parameter so upower could understand that the battery is powering
> a device and not the system.
> 
> Also, when did it become OK to force-enable a new feature that is
> _known_ to not work properly on recent userspace?  That makes no sense
> to me.

I agree. It's a great feature, but it shouldn't be default y if 
userspace isn't ready for it yet.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
