Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab2IVUrq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 16:47:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49541 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab2IVUro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 16:47:44 -0400
Date: Sat, 22 Sep 2012 22:47:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Nestor Lopez Casado <nlopezcasad@logitech.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        685360@bugs.debian.org, john.ettedgui@gmail.com, barz621@gmail.com,
        joy@debbugs.entuzijast.net, dh.herrmann@googlemail.com
Subject: Re: [PATCH 1/1] HID: Fix missing Unifying device issue
In-Reply-To: <alpine.LNX.2.00.1209220949380.32086@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1209222246320.32086@pobox.suse.cz>
References: <1348222894-6767-1-git-send-email-nlopezcasad@logitech.com> <alpine.LNX.2.00.1209220949380.32086@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Sep 2012, Jiri Kosina wrote:

> > This patch fixes an issue introduced after commit 4ea5454203d991ec
> > 
> > After that commit, hid-core silently discards any incoming packet
> > that arrives while any hid driver's probe function is being executed.
> > 
> > This broke the enumeration process of hid-logitech-dj, that must
> > receive control packets in-band with the mouse and keyboard
> > packets. Discarding mouse or keyboard data at the very begining is
> > usually fine, but it is not the case for control packets.
> > 
> > This patch forces a re-enumeration of the paired devices when a packet
> > arrives that comes from an unknown device.
> > 
> > Based on a patch originally written by Benjamin Tissoires.
> > 
> > Signed-off-by: Nestor Lopez Casado <nlopezcasad@logitech.com>
> 
> I am now applying it, will be pushing to Linus very soon

Now in Linus' tree and marked for stable.

Thanks,

-- 
Jiri Kosina
SUSE Labs
