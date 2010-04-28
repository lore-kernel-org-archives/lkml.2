Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab0D1PyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:54:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44000 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754139Ab0D1PyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:54:08 -0400
Date: Wed, 28 Apr 2010 11:54:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
cc: Robert Hancock <hancockrwd@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: INFO: umount blocked for more than 120 seconds
In-Reply-To: <20100428080027.GB30496@swordfish.minsk.epam.com>
Message-ID: <Pine.LNX.4.44L0.1004281153390.1944-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010, Sergey Senozhatsky wrote:

> On (04/27/10 15:07), Alan Stern wrote:
> > Robert was right.  Your usbmon log covers only the last 40 seconds of
> > data transfer and showed a little over 15 MB being sent, so it seems
> > likely that the entire 246 MB transfer would require more than 10
> > minutes.
> > 
> 
> Thanks.
> 
> > You can test this easily enough by simply waiting for 12 minutes or so
> > before issuing the "umount" command.
> > 
> So, bug entry is invalid. Right?

Right.  It's not a bug; it's a normal operation that happens to take a 
long time.

Alan Stern

