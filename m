Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678Ab0KOWbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 17:31:31 -0500
Received: from cantor.suse.de ([195.135.220.2]:56674 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758650Ab0KOWba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:31:30 -0500
Date: Mon, 15 Nov 2010 23:31:29 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Greg KH <gregkh@suse.de>
Cc: Stefan Achatz <erazor_de@users.sourceforge.net>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] HID: roccat: finishing usage of
 sysfs_create_bin_group()
In-Reply-To: <20101115220828.GA9417@suse.de>
Message-ID: <alpine.LNX.2.00.1011152330540.7420@pobox.suse.cz>
References: <1289853161.2188.44.camel@neuromancer> <20101115220828.GA9417@suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010, Greg KH wrote:

> > These patches are against the newest roccat file versions (after
> > applying everything I released the last days).
> > They fix some inattentive (though not critical) failures from previous
> > patches and change hid-roccat-koneplus and hid-roccat-pyra to use the
> > new sysfs_create_bin_group()
> > koneplus should be finished now (until I find errors)
> 
> Wait, they still don't resolve the main problem of this api is still
> racy and I can't accept it.

Yeah, I have already pointed Stefan to

	 http://lkml.org/lkml/2010/11/13/174

which he might have missed.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
