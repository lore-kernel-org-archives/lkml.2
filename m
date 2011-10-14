Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab1JNOA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 10:00:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab1JNOA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 10:00:26 -0400
Date: Fri, 14 Oct 2011 16:00:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>, Benson Leung <bleung@chromium.org>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: usbhid: enable remote wakeup for mice
In-Reply-To: <Pine.LNX.4.44L0.1110140955030.2036-100000@iolanthe.rowland.org>
Message-ID: <alpine.LNX.2.00.1110141559220.14768@pobox.suse.cz>
References: <Pine.LNX.4.44L0.1110140955030.2036-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Alan Stern wrote:

> In addition, unlike keyboards, a lot of mice don't work very well when 
> they are suspended.  For example, many won't wake up when they are 
> moved (especially optical mice) and some don't even wake up when a 
> button is pressed.

To stress it even more, I have tried with various types and brands of 
optical mouse, and I haven't encountered a single one that would wake up 
when moved.

> This patch definitely should not be merged.

I am not planning to do that.

Thanks,

-- 
Jiri Kosina
SUSE Labs
