Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab1LUKTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 05:19:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59526 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622Ab1LUKT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 05:19:29 -0500
Date: Wed, 21 Dec 2011 11:19:26 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Oliver Neukum <oneukum@suse.de>
Cc: Daniel Kurtz <djkurtz@chromium.org>, bleung@chromium.org,
        stern@rowland.harvard.edu, olofj@chromium.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 3/3] HID: usbhid: defer LED setting to a workqueue
In-Reply-To: <201112201118.24342.oneukum@suse.de>
Message-ID: <alpine.LNX.2.00.1112211119190.8727@pobox.suse.cz>
References: <1321529030-7845-1-git-send-email-djkurtz@chromium.org> <201112151001.52761.oneukum@suse.de> <CAGS+omCLU6FAxmT3+TgYf0b8YvgfbH9CL9M6WpZ0yNS01O5Hrw@mail.gmail.com> <201112201118.24342.oneukum@suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Dec 2011, Oliver Neukum wrote:

> > > > Could you please be more specific about what this patch breaks and
> > > > perhaps give some guidance on how to fix it?
> > >
> > > It breaks nothing. It just continues a bug and I assumed it was not present.
> > > Basically the work queue must do nothing after pre_reset() and post_reset()
> > > ought to rerun the work in case some request came down during that time.
> > 
> > So, is this an Ack for this patchset?
> > Can we fix any existing races in later patches?
> 
> Very well. You are fixing a bad bug and not making matters worse.
> 
> Acked-by: Oliver Neukum <oneukum@suse.de>

Thanks guys. Applied.

-- 
Jiri Kosina
SUSE Labs
