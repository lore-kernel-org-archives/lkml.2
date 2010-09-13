Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab0IML20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 07:28:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40950 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab0IML2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 07:28:25 -0400
Date: Mon, 13 Sep 2010 13:28:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Guillaume Chazarain <guichaz@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix hiddev's use of usb_find_interface
In-Reply-To: <201009131325.01768.arnd@arndb.de>
Message-ID: <alpine.LNX.2.00.1009131327060.26813@pobox.suse.cz>
References: <1284319955-6014-1-git-send-email-guichaz@gmail.com> <201009131325.01768.arnd@arndb.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010, Arnd Bergmann wrote:

> > My macbook infrared remote control was broken by commit
> > bd25f4dd6972755579d0ea50d1a5ace2e9b00d1a:
> > HID: hiddev: use usb_find_interface, get rid of BKL
> 
> Right, my bug. Sorry for the trouble you went through.
> 
> A few other people have reported the same and Jiri has done
> a fix that was merged in 2.6.36-rc2.

Yeah -- Guillaume, I think that you are actually seeing symptoms of 
intfdata being bogus. Could you please try with any kernel with commit 
9c9e54a8df0be48 ("HID: hiddev: fix memory corruption due to invalid 
intfdata") applied (which is the one Arnd is talking about) and report 
back whether the problem is fixed by it?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
