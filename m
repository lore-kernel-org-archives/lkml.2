Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156Ab2C3Ip2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 04:45:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37367 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759611Ab2C3IpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 04:45:20 -0400
Date: Fri, 30 Mar 2012 10:45:18 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jiri Kosina <jikos@jikos.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Przemo Firszt <przemo@firszt.eu>
Subject: Re: linux-next: build warning after merge of the hid tree
In-Reply-To: <20120329115117.70e8660dbd0c73354486eba9@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1203301043180.25526@pobox.suse.cz>
References: <20120329115117.70e8660dbd0c73354486eba9@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2012, Stephen Rothwell wrote:

> After merging the hid tree, today's linux-next build (x86_64 allmodconfig)
> produced this warning:
> 
> drivers/hid/Kconfig:595:error: recursive dependency detected!
> drivers/hid/Kconfig:595:	symbol HID_WACOM depends on HID_WACOM
> 
> Caused (very obviously) by commit 224b321b312e ("HID: wacom: Remove
> CONFIG_HID_WACOM_POWER_SUPPLY option").

Yeah, it has been already fixed in my tree a few hours after the first 
commit, but I raced with you snapshotting the tree. It should be gone now.

> Please test this stuff.  And don't rush stuff in during the merge window ...

Hm, I accidentally pushed it out to for-next, even though it's not 
destined for current merge window. Will flush the for-next branch now, 
sorry for that. I don't have anything pending for this merge window at the 
moment, so the for-next queue definitely should be empty.

Thanks,

-- 
Jiri Kosina
SUSE Labs
