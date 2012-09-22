Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab2IVHuf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 03:50:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44127 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab2IVHue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 03:50:34 -0400
Date: Sat, 22 Sep 2012 09:50:22 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Nestor Lopez Casado <nlopezcasad@logitech.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        685360@bugs.debian.org, john.ettedgui@gmail.com, barz621@gmail.com,
        joy@debbugs.entuzijast.net, dh.herrmann@googlemail.com
Subject: Re: [PATCH 1/1] HID: Fix missing Unifying device issue
In-Reply-To: <1348222894-6767-1-git-send-email-nlopezcasad@logitech.com>
Message-ID: <alpine.LNX.2.00.1209220949380.32086@pobox.suse.cz>
References: <1348222894-6767-1-git-send-email-nlopezcasad@logitech.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2012, Nestor Lopez Casado wrote:

> This patch fixes an issue introduced after commit 4ea5454203d991ec
> 
> After that commit, hid-core silently discards any incoming packet
> that arrives while any hid driver's probe function is being executed.
> 
> This broke the enumeration process of hid-logitech-dj, that must
> receive control packets in-band with the mouse and keyboard
> packets. Discarding mouse or keyboard data at the very begining is
> usually fine, but it is not the case for control packets.
> 
> This patch forces a re-enumeration of the paired devices when a packet
> arrives that comes from an unknown device.
> 
> Based on a patch originally written by Benjamin Tissoires.
> 
> Signed-off-by: Nestor Lopez Casado <nlopezcasad@logitech.com>

I am now applying it, will be pushing to Linus very soon, and am also 
marking it for stable 3.2+

Thanks to everyone involved.

-- 
Jiri Kosina
SUSE Labs
