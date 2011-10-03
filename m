Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab1JCMPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 08:15:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49816 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520Ab1JCMPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 08:15:43 -0400
Date: Mon, 3 Oct 2011 14:15:41 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Add support MacbookAir 4,1 keyboard
In-Reply-To: <alpine.LNX.2.00.1110031402360.31654@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1110031415110.31654@pobox.suse.cz>
References: <1317452093-25555-1-git-send-email-iwamatsu@nigauri.org> <alpine.LNX.2.00.1110031402360.31654@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Oct 2011, Jiri Kosina wrote:

> > Added USB device IDs and keyboard map for MacBookAir 4,1 keyboard.
> > 
> > Signed-off-by: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
> 
> Applied, thank you.

Oh, and don't we BTW need the hid_mouse_ignore_list[] addition as well? Is 
the respective mouse being handled properly by appletouch driver?

-- 
Jiri Kosina
SUSE Labs
