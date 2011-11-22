Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850Ab1KVWgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:36:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758827Ab1KVWgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:36:19 -0500
Date: Tue, 22 Nov 2011 14:16:33 -0800
From: Greg KH <gregkh@suse.de>
To: Corentin Chary <corentincj@iksaif.net>
Cc: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/15] samsung-laptop: don't handle backlight if handled
 by acpi/video
Message-ID: <20111122221633.GA24283@suse.de>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
 <1321999366-23784-4-git-send-email-corentincj@iksaif.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321999366-23784-4-git-send-email-corentincj@iksaif.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 11:02:34PM +0100, Corentin Chary wrote:
> samsung-laptop is not at all related to ACPI, but since this interface
> is not documented at all, and the driver has to use it at load to
> understand how it works on the laptop, I think it's a good idea to
> disable it if a better solution is available.

I wish this would work, but on the machine that I had, there was a valid
ACPI table for the video device, yet I was told to "ignore it, it
doesn't work and use the sabi interface instead", so this patch would
break that machine :(

We might want to trigger off of the machine type for this kind of
thing, that's the only way I can see this working properly.

So, sorry, I can't approve this patch.

greg k-h
