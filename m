Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910Ab1KVWhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:37:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33460 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932272Ab1KVWhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:37:00 -0500
Date: Tue, 22 Nov 2011 14:27:30 -0800
From: Greg KH <gregkh@suse.de>
To: Corentin Chary <corentincj@iksaif.net>
Cc: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] samsung-laptop: make the dmi check less strict
Message-ID: <20111122222730.GM24283@suse.de>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
 <1321999366-23784-14-git-send-email-corentincj@iksaif.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321999366-23784-14-git-send-email-corentincj@iksaif.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 11:02:44PM +0100, Corentin Chary wrote:
> This enable the driver for everything that look like
> a laptop and is from vendor "SAMSUNG ELECTRONICS CO., LTD.".
> Note that laptop supported by samsung-q10 seem to have a different
> vendor strict.
> 
> Also remove every log output until we know that we have a SABI interface
> (except if the driver is forced to load, or debug is enabled).
> 
> Keeping a whitelist of laptop with a model granularity is something that can't
> work without close vendor cooperation (and we don't have that).
> 
> Signed-off-by: Corentin Chary <corentincj@iksaif.net>

Oh, this is bold.

I would like to see this work, but I would need to see it tested on a
bunch of machines before I trust it.

I guess you now have the acpi video backlight check, which is good, but
again, doesn't work for all devices.

And yeah, a whitelist is tough, especially as the vendor isn't working
with us at all, but I don't want to break machines that don't need this
driver (and there are some, although I thought the newest ones would not
need it, but that might be true.)

Hm, if you can figure out how to get the acpi-video thing working for
some machines properly, I'll support this kind of change.

thanks,

greg k-h
