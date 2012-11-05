Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab2KEUSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 15:18:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab2KEUSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 15:18:20 -0500
Date: Mon, 5 Nov 2012 21:18:16 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Chris J Arges <chris.j.arges@canonical.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] hid: usbhid: add quirk for SB arena headset v2
In-Reply-To: <1352145945-8035-1-git-send-email-chris.j.arges@canonical.com>
Message-ID: <alpine.LNX.2.00.1211052117210.24253@pobox.suse.cz>
References: <1352145945-8035-1-git-send-email-chris.j.arges@canonical.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2012, Chris J Arges wrote:

> When an SB Arena USB headset is plugged in, it registers the volume
> keys on the headset as a keyboard and continually sends events causing
> issues with normal keyboard input. This quirk disables the volume keys.

I don't know how the device looks like, but wouldn't it make more sense to 
actually remap the bogus keys it's sending to produce KEY_VOLUMEUP and 
KEY_VOLUMEDOWN?

-- 
Jiri Kosina
SUSE Labs
