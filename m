Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386Ab2KFLOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 06:14:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41492 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab2KFLOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 06:14:48 -0500
Date: Tue, 6 Nov 2012 12:14:45 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Chris J Arges <chris.j.arges@canonical.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] hid: usbhid: add quirk for SB arena headset v2
In-Reply-To: <50983069.5080404@canonical.com>
Message-ID: <alpine.LNX.2.00.1211061214030.24253@pobox.suse.cz>
References: <1352145945-8035-1-git-send-email-chris.j.arges@canonical.com> <alpine.LNX.2.00.1211052117210.24253@pobox.suse.cz> <50983069.5080404@canonical.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2012, Chris J Arges wrote:

> >> When an SB Arena USB headset is plugged in, it registers the volume
> >> keys on the headset as a keyboard and continually sends events causing
> >> issues with normal keyboard input. This quirk disables the volume keys.
> > 
> > I don't know how the device looks like, but wouldn't it make more sense to 
> > actually remap the bogus keys it's sending to produce KEY_VOLUMEUP and 
> > KEY_VOLUMEDOWN?
> > 
> 
> Yes, if I can track this hardware down or get data I'll fix it like
> this. This happened to be a do-no harm fix for the following bug:
> https://bugs.launchpad.net/ubuntu/+source/xorg-server/+bug/1007575

You should be able to obtain it easily either by running evtest on 
corresponding /dev/input/eventX node, or by looking into debugfs 
hid/<device>/events file.

-- 
Jiri Kosina
SUSE Labs
