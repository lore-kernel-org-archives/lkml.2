Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab1JDPex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 11:34:53 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54601 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932386Ab1JDPev convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 11:34:51 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1110041007070.1954-100000@iolanthe.rowland.org>
References: <CADDb1s0ZnHzM72sDnFmRrM=GFJtxj5JkYUSPo6GdyQ_=7L2m9A@mail.gmail.com>
	<Pine.LNX.4.44L0.1110041007070.1954-100000@iolanthe.rowland.org>
Date: Tue, 4 Oct 2011 21:04:49 +0530
Message-ID: <CADDb1s0taBR2=xpKE5rLJTWJBMbXijS8b_GEA-MbZvWKFDFvYg@mail.gmail.com>
Subject: =?windows-1252?Q?Re=3A_Re=3A_Re=3A_BUG_in_kernel=3A_Wrong_Handling_of_USB_HDD?=
	=?windows-1252?Q?=92s_in_scsiglue=28slave=5Fconfigure=29_and_scsi=2Fsd=28sd=5Fread=5Fcache=5F?=
	=?windows-1252?Q?type=29?=
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 4, 2011 at 7:40 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 4 Oct 2011, Amit Sahrawat wrote:
>
>> Not able to get tools which can show the Caching Information when
>> connected USB device to Windows 7(Except one option which allows for
>> optimizing Performance by enabling/disabling Cache - But that option
>> is available for all the Mass storage device) - Please let me know if
>> there is option to view this.
>
> I have no idea.
>
>> So, I have collected USB analyzer logs for Device after connected to
>> Windows 7.  Please find the attached logs.
>
> It would be more informative if your logs did not show the initial
> connection, but did show what happens when you write a small file to
> the drive and then go through the "Safely Remove Hardware" procedure.
>
> The real question is whether or not Windows sends a SYNCHRONIZE CACHE
> command to the drive.
ok, I will try this out and provide the results tomorrow early morning.
>
> Alan Stern
>
>
Thanks & Regards,
Amit Sahrawat
