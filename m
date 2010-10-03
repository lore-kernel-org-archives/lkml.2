Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab0JCWNu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 18:13:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62102 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab0JCWNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 18:13:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=cz6TNmgn0i6nvy6mjNb8oyAL5TzEeqd8CyNKAhGlu6TGrfTS4w3qGRZ7cRsI9hHuJr
         fuAfhjqzlyLKtrO/AWbZGPiUkK8gETV+Hm/GD2+hOwoOs/3NWypxrrCBFeLf9nDsGXsI
         jF+tRDAflTBG3ZNgWK7RFCV6NP+vhf1nthyLA=
MIME-Version: 1.0
In-Reply-To: <1286118002-2354-1-git-send-email-sbalashanmugam@atheros.com>
References: <1286118002-2354-1-git-send-email-sbalashanmugam@atheros.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 4 Oct 2010 09:13:27 +1100
Message-ID: <AANLkTinpE-3Ku9=WFyOO8XYUWkxj3oVvgi3QTt491jZq@mail.gmail.com>
Subject: Re: [PATCH] Added firmware load patch to crap directory.
To: Bala Shanmugam <sbalashanmugam@atheros.com>
Cc: linux-wireless@vger.kernel.org, marcel@holtmann.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 4, 2010 at 02:00, Bala Shanmugam <sbalashanmugam@atheros.com> wrote:
> +Reason for not yet publishing: Marcel feels that Atheros sflash based BT device
> +doesn't follow bluetooth H:2 specification and HCI commands should be supported
> +in firmware if it is detected as bluetooth device. Using HCI command, firmware
> +should be loaded.
> +
> +In sflash based device there is not enough memory to support HCI commands in firmware.
> +So load firmware from btusb when the device comes up.

Stupid question: What's to stop you from producing a driver that
connects to this device when unflashed, loads the firmware, then hands
it over to the proper HCI bluetooth driver? (other than it being an
ugly hack)

You could post such a driver to Linux-usb and "solve" the problem in a
way that (should) make everyone happy.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
