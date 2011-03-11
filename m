Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab1CKXCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 18:02:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963Ab1CKXCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 18:02:07 -0500
Date: Sat, 12 Mar 2011 00:02:05 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] hid-input: Keyboard and MT support for MacBookPro8
In-Reply-To: <1299869123-18346-1-git-send-email-rydberg@euromail.se>
Message-ID: <alpine.LNX.2.00.1103120001020.19969@pobox.suse.cz>
References: <1299869123-18346-1-git-send-email-rydberg@euromail.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Mar 2011, Henrik Rydberg wrote:

> Hi Jiri, Dmitry,
> 
> Keyboard and MT support for the new MacBookPro models. The first patch
> is against HID, the second against Input. As usual, they need to be
> synced.
> 
> The patches have been tested on the Ubuntu forums, many thanks to Andy
> for the nice patches.

Thanks a lot Henrik for relaying those patches.

Dmitry, what tree would you prefer these patches to go through? I am fine 
either way, and

	Signed-off-by: Jiri Kosina <jkosina@suse.cz>

for the HID changes.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
