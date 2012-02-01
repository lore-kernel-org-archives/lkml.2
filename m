Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab2BALtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 06:49:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59760 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144Ab2BALtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 06:49:04 -0500
Date: Wed, 1 Feb 2012 12:48:57 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] HID
In-Reply-To: <4F1132B3.3000909@goop.org>
Message-ID: <alpine.LNX.2.00.1202011247550.18918@pobox.suse.cz>
References: <alpine.LNX.2.00.1201052218200.24984@pobox.suse.cz> <4F098C29.9010101@goop.org> <alpine.LNX.2.00.1201081739360.24984@pobox.suse.cz> <4F1132B3.3000909@goop.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jan 2012, Jeremy Fitzhardinge wrote:

> > which is based on the power supply scope changes in the battery.git tree; I'm not quite
> > sure how to sequence that into mainline.
> > I will look into it.
> 
> The power changes are in now, so you could try pushing them as a late push.
> 
> (Linus: I had some changes that depended on both the HID and
> power_supply subsystems, so they needed to wait until you'd pulled both.)

Jeremy,

I have been completely offline for ~20 days, and am slowly getting back on 
track now, so I will process those shortly. Sorry for late response.

-- 
Jiri Kosina
SUSE Labs
