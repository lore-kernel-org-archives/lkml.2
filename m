Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab0INPaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 11:30:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:42156 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab0INPaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 11:30:07 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] wacom + runtime PM = AA deadlock
Date: Tue, 14 Sep 2010 17:30:38 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Jiri Slaby <jslaby@suse.cz>, Dmitry Torokhov <dtor@mail.ru>,
        pingc@wacom.com, "linux-pm" <linux-pm@lists.linux-foundation.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org
References: <Pine.LNX.4.44L0.1009141119340.1648-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1009141119340.1648-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009141730.38215.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 14. September 2010, 17:23:15 schrieb Alan Stern:
> On Tue, 14 Sep 2010, Oliver Neukum wrote:
> 
> > > > Should I have used usb_autopm_get_interface_no_resume()?
> > > 
> > > That actually would work.  It's a good idea.  The only drawback (not a
> > > big one) is that if the device _was_ suspended with remote wakeup
> > > enabled, doing this wouldn't turn off remote wakeup.  I think that
> > > doesn't matter.
> > 
> > I am afraid it does matter as devices whose remote wakeup is enabled
> > may draw more power.
> 
> I doubt it, or at least, not very much more.  They are still limited by 
> the USB spec as to the total amount of current they can draw while 
> suspended.

7.2.3 Sources of remote wakeup may draw 2.5mA when suspended
as opposed to 0.5 mA

	Regards
		Oliver
