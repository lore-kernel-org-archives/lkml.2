Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab1LTKQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 05:16:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42720 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047Ab1LTKQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 05:16:51 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Daniel Kurtz <djkurtz@chromium.org>
Subject: Re: [PATCH 3/3] HID: usbhid: defer LED setting to a workqueue
Date: Tue, 20 Dec 2011 11:18:24 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: jkosina@suse.cz, bleung@chromium.org, stern@rowland.harvard.edu,
        olofj@chromium.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <1321529030-7845-1-git-send-email-djkurtz@chromium.org> <201112151001.52761.oneukum@suse.de> <CAGS+omCLU6FAxmT3+TgYf0b8YvgfbH9CL9M6WpZ0yNS01O5Hrw@mail.gmail.com>
In-Reply-To: <CAGS+omCLU6FAxmT3+TgYf0b8YvgfbH9CL9M6WpZ0yNS01O5Hrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201112201118.24342.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 20. Dezember 2011, 11:12:37 schrieb Daniel Kurtz:
> > > Could you please be more specific about what this patch breaks and
> > > perhaps give some guidance on how to fix it?
> >
> > It breaks nothing. It just continues a bug and I assumed it was not present.
> > Basically the work queue must do nothing after pre_reset() and post_reset()
> > ought to rerun the work in case some request came down during that time.
> 
> So, is this an Ack for this patchset?
> Can we fix any existing races in later patches?

Very well. You are fixing a bad bug and not making matters worse.

Acked-by: Oliver Neukum <oneukum@suse.de>

	Regards
		Oliver
-- 
- - - 
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg) 
Maxfeldstraße 5                         
90409 Nürnberg 
Germany 
- - - 
