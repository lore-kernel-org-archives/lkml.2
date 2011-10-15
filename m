Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab1JOTHc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 15:07:32 -0400
Received: from netrider.rowland.org ([192.131.102.5]:35653 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754530Ab1JOTHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 15:07:31 -0400
Date: Sat, 15 Oct 2011 15:07:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Benson Leung <bleung@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        <linux-usb@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] HID: usbhid: enable remote wakeup for mice
In-Reply-To: <201110151143.27061.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.1110151504510.15129-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Oct 2011, Oliver Neukum wrote:

> Am Freitag, 14. Oktober 2011, 17:09:32 schrieb Alan Stern:
> > > Anyway, I'll solve this problem on my system by writing to wakeup
> > > property on device attach. Consider my change abandoned.
> > 
> > That seems like the best approach.
> 
> Do you think this could be added to the USB configuration tool I wrote
> last week?

I don't see why not.  It's exactly the sort of thing that should be 
handled on a per-user basis.

> In the longer run, we might consider that this properties may also need
> to be changed based on AC vs. DC or the battery's charge level.

Is that really true?  I'm not sure -- in general people want their 
computers to be consistent.  In particular, they want to conserve power 
regardless of the power source.

However, you could add such a mechanism to the program in case some 
people do want to use it.

Alan Stern

