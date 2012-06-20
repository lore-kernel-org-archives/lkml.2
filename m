Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab2FTPFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 11:05:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36993 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756699Ab2FTPFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 11:05:05 -0400
Date: Wed, 20 Jun 2012 11:05:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Vishal Nandanwar <operational.people@gmail.com>
cc: Linux Docs <linux-doc@vger.kernel.org>,
        Linux Embedded Group <linux-embedded@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux USB <linux-usb@vger.kernel.org>,
        Platform driver x86 <platform-driver-x86@vger.kernel.org>
Subject: Re: Need help regarding the USB mass storage driver
In-Reply-To: <CAKB833nfHQwdHzCFV6ELrk1-XZT-SN8WxMs=kzO=C8+6foTrDQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1206201100410.1804-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2012, Vishal Nandanwar wrote:

> Hi,
> 
> I am working on a USB mass storage driver for a pen drive. I have done
> coding as per the USB_skeleton.c file provided in Linux 3.2 source
> code. I could assign the driver to pen drive when pen driver is
> inserted in USB connector.

Do you understand that the usb_skeleton.c file is totally inappropriate 
as a model for a mass-storage driver?

> I am stuck in data transfer,  could not do the data transfer. During
> enumeration interface sub class is 06 i.e. SCSI transparent command
> set. Please find my questions below.
> 
> 1. Where are these SCSI transparent command set documented?

Google is your friend.  But see the answer to your next question...

> 2. Is there any sample code(apart from Linux source) which describes
> the SCSI transparent command set and mass storage driver?

There is no such thing as the SCSI transparent command set.  "SCSI 
transparent" means "use whatever command set the relevant SCSI standard 
specifies".

There is non-Linux source code for mass-storage drivers in other
open-source operating systems.

> 3. When I connect the pen drive and associate my driver, pop up
> doesn't appear on the screen for this device. but when default
> driver(usb_storage) is used this pop up does appear. What I need to do
> here?

Fix your driver.  It's not possible to give a more complete answer 
without further information.

Alan Stern

