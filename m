Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab0GVO1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 10:27:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54001 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab0GVO1l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 10:27:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jEbma6DihiWkFTCzqohrUhUKzX19P2aa7N4gEOzmkxduNpWJHKTADxWU6REwYoS4Va
         zfRb8zEqDiDDpfPw9cf58bFAj4jsHgisvEd8Fx14lycqsqn4KSY2RVDL5F02OWEPe4z/
         UDHd9tydMbri8AD4w8fgE/NOZF7J1agd1a9zI=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1007221007210.1725-100000@iolanthe.rowland.org>
References: <1279789128-11399-2-git-send-email-ext-andriy.shevchenko@nokia.com>
	<Pine.LNX.4.44L0.1007221007210.1725-100000@iolanthe.rowland.org>
Date: Thu, 22 Jul 2010 17:27:38 +0300
Message-ID: <AANLkTimiOweb2baUzbNepjeXOfg82mpa5RX7kaH0F9Ow@mail.gmail.com>
Subject: Re: [PATCHv4 2/2] usb: gadget: storage: optional SCSI WRITE FUA bit
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Denis Karpov <ext-denis.2.karpov@nokia.com>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 5:13 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> +What:           /sys/devices/platform/musb_hdrc/gadget/gadget-lun-X/nofua
>
> The name of the new file and the path given here shouldn't mention
> musb_hdrc.  That's what _you_ see because that's the device controller
> driver you use, but other people will see something different.  As a
> simple test, you might try using dummy_hcd instead and see what the
> name turns out to be.
>
> Just put "..." instead of "musb_hdrc", or something like that.
Thanks for point.

Actually this seems to be part of exist sysfs-devices-platform-_UDC_-gadget.

-- 
With Best Regards,
Andy Shevchenko
