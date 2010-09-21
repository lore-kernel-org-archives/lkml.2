Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab0IUNOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 09:14:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:55190 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932Ab0IUNOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 09:14:22 -0400
Date: Tue, 21 Sep 2010 15:14:18 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Heinz Diehl <htd@fritha.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Heinz Diehl <htd@fancy-poultry.org>, Alan Ott <alan@signal11.us>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [BUG] object: is not initialized, yet kobject_put() is being
 called
In-Reply-To: <20100920193913.GA6448@fritha.org>
Message-ID: <alpine.LNX.2.00.1009211513440.26813@pobox.suse.cz>
References: <20100920181100.GA12295@fancy-poultry.org> <Pine.LNX.4.44L0.1009201456260.2010-100000@iolanthe.rowland.org> <20100920193913.GA6448@fritha.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010, Heinz Diehl wrote:

> > No, you're wrong.  The patch _is_ in 2.6.36-rc4, and that's the reason 
> > why it doesn't apply any longer.
> 
> Yes, you're right. 
> 
> > The error you see must have a different cause.  Have you read this 
> > thread?
> > 
> > 	http://marc.info/?t=128494644600005&r=1&w=2
> 
> No, not before until now. This problem seems not to be related to what I 
> see on my machines, and reverting commit 8fe294caf8c868edd9046251824a0af91991bf43 as
> mentioned in there doesn't help either.
> 
> 2.6.35.4 works, 2.6.36-rc4 does not. What can I do to help to find the
> issue?
> 
> Attached are the dmesg output for both 2.6.35.4 and 2.6.36-rc4.

Just to verify that you are really being hit by the same issue -- you are 
using CONFIG_USB_DYNAMIC_MINORS, aren't you? Does the problem go away if 
you disable this?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
