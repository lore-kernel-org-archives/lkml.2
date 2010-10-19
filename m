Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab0JSJsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 05:48:18 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49604 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab0JSJsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 05:48:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=VaovqkD67Y47qcNLFww/oF7UHr/Kb0Sv6xkQclgEfhjPxml5XcHuFb6ncwJP2Tnq6z
         rvANMAjY8Ulqx3HvXY+gZ2VblQhsJjkMGaRiqbYBq71jmZ39czwJ57OKyqGgyhLQZxzW
         RCrf9+Y1N+0kW58bjfKtkT1gIQUiiUU1z7rA0=
MIME-Version: 1.0
In-Reply-To: <AANLkTik5UwEqSfAem-yL4yQz+sap97m50EMuyS-E2t9s@mail.gmail.com>
References: <AANLkTik5UwEqSfAem-yL4yQz+sap97m50EMuyS-E2t9s@mail.gmail.com>
Date: Tue, 19 Oct 2010 12:48:16 +0300
Message-ID: <AANLkTik=JqAsr0gyAd7fY-JrrwSXpcd9EEUyqkrxqFhw@mail.gmail.com>
Subject: bind a usb device to a driver
From: Pavlos Vinieratos <pvinis@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello.

I am writing a usb device driver. I have written most of the driver,
and I have tried with the usb-skeleton with my product and vendor id,
to insmod the driver and then unbind the device from usbhid and bind
it to my driver. I use echo -n "3-2:1.0" > /sys/bus/usb/...../unbind
and bind. It unbinds, but the binding fails. echo says there is no
such device..
I tried blacklisting the hid_sony that gets loaded. should I blacklist
hid as well? will I be able to use my mouse and keyboard then? I tried
making a rule in modprobe.d. nothing..
What should I do?

I then tried writing a user space driver, but after I set everything
up (configs, interfaces..) usb_interrupt_read always returns -110
(device busy)..

help?
thanks
