Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934431Ab1JEORX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 10:17:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60096 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934345Ab1JEORV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 10:17:21 -0400
Date: Wed, 5 Oct 2011 10:17:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Douglas Gilbert <dgilbert@interlog.com>, <linux-usb@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: Re: =?windows-1252?Q?Re=3A_Re=3A_Re=3A_BUG_in_kernel=3A_Wrong_Handling_of_USB_HDD?=
 =?windows-1252?Q?=92s_in_scsiglue=28slave=5Fconfigure=29_and_scsi=2Fsd=28sd=5Fread=5Fcache=5F?=
 =?windows-1252?Q?type=29
In-Reply-To: <CADDb1s3sPxpfNi-OD=QvVT+JWO9kUeTAmb8ZGyN0YCuBKWd4rg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1110051014590.2289-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Oct 2011, Amit Sahrawat wrote:

> Hi,
> 
> In order to verify the SYNC_CACHE command being passed.
> First I checked on the USB HDD(Seagate - Free Agent) which is gettind
> properly identified on linux. I performed - copy of a file and then
> did 'Safely Remove Hardware" - this resulted in SYNC_CACHE command
> being passed - All logs are captured for this.
> 
> Then, for the same Hard Disk - I checked for the behaviour on Windows.
> There is no SYNC CACHE command being passed in this case.
> 
> Again, checked for a different hard disk(Seagate) - which has cache
> but not shown in Linux. In that case also, there is no SYNC CACHE
> command.
> 
> Please find the logs for the '3' cases attached.

This is a little disappointing.  If Windows doesn't use the SYNCHRONIZE 
CACHE command, it's quite likely that some USB drives will crash when 
they receive it.

This strongly suggests that we should not change the current code.

Alan Stern

