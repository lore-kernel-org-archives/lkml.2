Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643Ab0KOWIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 17:08:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976Ab0KOWIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:08:42 -0500
Date: Mon, 15 Nov 2010 14:08:28 -0800
From: Greg KH <gregkh@suse.de>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] HID: roccat: finishing usage of
 sysfs_create_bin_group()
Message-ID: <20101115220828.GA9417@suse.de>
References: <1289853161.2188.44.camel@neuromancer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289853161.2188.44.camel@neuromancer>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 09:32:41PM +0100, Stefan Achatz wrote:
> These patches are against the newest roccat file versions (after
> applying everything I released the last days).
> They fix some inattentive (though not critical) failures from previous
> patches and change hid-roccat-koneplus and hid-roccat-pyra to use the
> new sysfs_create_bin_group()
> koneplus should be finished now (until I find errors)

Wait, they still don't resolve the main problem of this api is still
racy and I can't accept it.

thanks,

greg k-h
