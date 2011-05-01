Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab1EAIAJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 04:00:09 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:34799 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab1EAIAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 04:00:07 -0400
X-Greylist: delayed 489 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 May 2011 04:00:07 EDT
From: Oliver Neukum <oliver@neukum.org>
To: "Adi J. Sieker" <adi@core.adi.io>, USB list <linux-usb@vger.kernel.org>
Subject: Re: USB keyboard recognized as HID keyboard but doesn't work
Date: Sun, 1 May 2011 09:53:27 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <4DBC6FA9.3080008@sieker.io>
In-Reply-To: <4DBC6FA9.3080008@sieker.io>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105010953.27052.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 30. April 2011, 22:23:05 schrieb Adi J. Sieker:
> Hello,
> 
> the lovely folks from #kernelnewbies suggested I write this mail since 
> they are at a loss.
> I recently got a new USB keyboard which works fine in the BIOS and also 
> in VBox Windows guests, but not on the host.
> 
> The keyboard is a Keysonic KSK-8003 UX product details here: 
> http://maxpoint.de/de/products/keyboards.php?pid=1_3_7&we_objectID=1220
> 
> The menu key and the backspace keys do work. The num lock led is on, 
> though I can't switch num lock off.
> If I attch the keyboard to a VirtualBox VM running WindowsXP as a guest, 
> it works as expected in the VM.

This indicates that it is working on the USB level.

> I'm running 2.6.32-27-generic #49-Ubuntu. I tried the Ubuntu 10.10 
> LiveCD and that also didn't work. I haven't tried 11.04 yet though.

Do you get anything on the event device? What does udev say when you
plug in the device?

	Regards
		Oliver
