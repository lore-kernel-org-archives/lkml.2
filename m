Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab2LMQs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 11:48:27 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:60999 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab2LMQsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 11:48:25 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1212121040000.1488-100000@iolanthe.rowland.org>
References: <50C823A5.3050904@gmail.com>
	<Pine.LNX.4.44L0.1212121040000.1488-100000@iolanthe.rowland.org>
Date: Thu, 13 Dec 2012 22:18:24 +0530
Message-ID: <CANc+2y6dhfv0XQG==GqhiKoP58L+ZjM6R8ASMVLSCLtSp71cOg@mail.gmail.com>
Subject: Re: Fwd: Safely remove option shows with Micro SD Card connected to
 Linux through an Android phone
From: prasannatsmkumar <prasannatsmkumar@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, nautilus-list@gnome.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 9:11 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> That's the error code returned by the USB stack when a request is
> cancelled synchronously.  But it is intended for internal kernel use
> only; it should not appear at the userspace level.  Without knowing the
> details of what the program did, it's hard to tell how that code got
> there.

I am not much aware of the nautilus code. May be people who work on
Nautilus will be able to provide this information.

Can any nautilus contributor or one who has idea of nautilus code
explain this? Having safe to remove and eject are great and fine
tuning them will be very useful for users.
