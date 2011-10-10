Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab1JJVCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 17:02:33 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64736 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab1JJVCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 17:02:32 -0400
Date: Mon, 10 Oct 2011 18:03:01 -0300
From: Gustavo Padovan <padovan@profusion.mobi>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 2/2] Bluetooth: btusb: hide more usb_submit_urb errors
Message-ID: <20111010210301.GB6936@joana>
Mail-Followup-To: Paul Bolle <pebolle@tiscali.nl>,
	Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
References: <1318155142.1903.24.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318155142.1903.24.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

* Paul Bolle <pebolle@tiscali.nl> [2011-10-09 12:12:22 +0200]:

> There are still three calls of usb_submit_urb() that will print errors
> if those calls return -EPERM or -ENODEV. I have never triggered these,
> so I'm not sure when these return values might be seen. It still makes
> sense to be silent if these occur (since "urb is being killed" and
> "device got disconnected" aren't things to worry about).
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  drivers/bluetooth/btusb.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)

Both patches have been applied. Thanks.

	Gustavo
