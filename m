Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab0ICSY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 14:24:27 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:52448 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757153Ab0ICSYZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 14:24:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=F/VNw6cfhJZVmzHgI8a+TF/y3EuDL8BvYZFUw5hwoKg66FZtTYIYTV+mvDbDxBZz+k
         6AI+6qdNRmYgOZScAXHLQ11ewVS3NIi6fAS4BsPQTP7qRviB5bs6M7DkjlXVIGc+W222
         iS0eQDtl9mdzD+wVlE/wDJTKSK1AnKIz/fVCw=
From: Diego Calleja <diegocg@gmail.com>
Reply-To: diegocg@gmail.com
To: "Henrik Rydberg" <rydberg@euromail.se>
Subject: Re: [PATCH 3/5] input: wacom: Add support for the Bamboo Touch trackpad (rev3)
Date: Fri, 3 Sep 2010 20:24:19 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-dirty; KDE/4.5.0; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ping Cheng <pingc@wacom.com>,
        Chris Bagwell <chris@cnpbagwell.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1283516247-11624-1-git-send-email-rydberg@euromail.se> <1283516247-11624-4-git-send-email-rydberg@euromail.se>
In-Reply-To: <1283516247-11624-4-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009032024.19745.diegocg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Viernes, 3 de Septiembre de 2010 14:17:25 Henrik Rydberg escribió:
> @@ -1280,6 +1361,7 @@ const struct usb_device_id wacom_ids[] = {
>  	{ USB_DEVICE_WACOM(0xC6) },
>  	{ USB_DEVICE_WACOM(0xC7) },
>  	{ USB_DEVICE_WACOM(0xCE) },
> +	{ USB_DEVICE_WACOM(0xD0) },
>  	{ USB_DEVICE_WACOM(0xF0) },
>  	{ USB_DEVICE_WACOM(0xCC) },
>  	{ USB_DEVICE_WACOM(0x90) },

I have a wacom bamboo touch & pen (CTH-461) with a 0xD2 id. Can I do
something to help to get it supported in these patches?
