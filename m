Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab3AJPhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 10:37:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab3AJPhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:37:09 -0500
From: Oliver Neukum <oneukum@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Josh Boyer <jwboyer@redhat.com>, gregkh@linuxfoundation.org,
        mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: USB autosuspend vs. URB submission
Date: Thu, 10 Jan 2013 16:37:06 +0100
Message-ID: <7574048.Em7ePkbmsJ@linux-5eaq.site>
Organization: SUSE
User-Agent: KMail/4.8.5 (Linux/3.4.11-2.16-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1301101015530.1178-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1301101015530.1178-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 January 2013 10:20:42 Alan Stern wrote:
> On Thu, 10 Jan 2013, Oliver Neukum wrote:

> > In the long run it is probably a good idea to pass duplicated URBs to usbmon by
> > a special code path.
> 
> I'd prefer to add extra information to the WARN_ONCE message.  Even 
> though it would require the extra effort of correlating the dmesg 
> output with the usbmon output.

A stack_trace() I presume.
But what is the use of needing two logs?

> You know, it's possible that the URB really was not submitted before 
> but instead the urb->hcpriv field got overwritten.  Of course, that 
> would also be a bug.

We could log a corrupted URB generically speaking.

	Regards
		Oliver

