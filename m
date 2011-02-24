Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab1BXCmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 21:42:23 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59435 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab1BXCmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 21:42:22 -0500
Date: Wed, 23 Feb 2011 23:42:51 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Marcel Holtmann <marcel@holtmann.org>, Matthew Garrett <mjg@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: btusb autosuspend (was Re: Linux 2.6.38-rc6)
Message-ID: <20110224024251.GA2155@joana>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Matthew Garrett <mjg@redhat.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Jeff Chua <jeff.chua.linux@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <AANLkTimTzjHkVQGPBRXrcb6M1_xaDY_==pB5ZyB9CJpR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimTzjHkVQGPBRXrcb6M1_xaDY_==pB5ZyB9CJpR@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

* Linus Torvalds <torvalds@linux-foundation.org> [2011-02-23 16:25:23 -0800]:

> Hmm. Is there any reason we shouldn't revert commit
> 556ea928f78a390fe16ae584e6433dff304d3014 given the regression?

Go ahead and revert it, I don't have too much clue on the USB autosuspend
subsystem to be able to fix this before the 2.6.38 release.
Then we can bring this patch back together with the fix for the -next release.

-- 
Gustavo F. Padovan
http://profusion.mobi
