Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab1JOJt5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 05:49:57 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:42006 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab1JOJt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 05:49:56 -0400
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Oct 2011 05:49:56 EDT
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] HID: usbhid: enable remote wakeup for mice
Date: Sat, 15 Oct 2011 11:43:27 +0200
User-Agent: KMail/1.13.5 (Linux/3.1.0-rc9-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Benson Leung <bleung@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1110141106270.2036-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1110141106270.2036-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110151143.27061.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 14. Oktober 2011, 17:09:32 schrieb Alan Stern:
> > Anyway, I'll solve this problem on my system by writing to wakeup
> > property on device attach. Consider my change abandoned.
> 
> That seems like the best approach.

Do you think this could be added to the USB configuration tool I wrote
last week?

In the longer run, we might consider that this properties may also need
to be changed based on AC vs. DC or the battery's charge level.

	Regards
		Oliver
