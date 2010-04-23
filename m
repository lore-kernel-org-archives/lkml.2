Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab0DWKod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 06:44:33 -0400
Received: from relay.ihostexchange.net ([66.46.182.52]:55286 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab0DWKob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 06:44:31 -0400
Message-ID: <4BD179FB.3010309@VirtualLogix.com>
Date: Fri, 23 Apr 2010 12:44:11 +0200
From: Eric Lescouet <Eric.Lescouet@VirtualLogix.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: USBIP (staging) driver's dependency on drivers/usb/core internal
 headers
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The USBIP modules (and some others) have a direct dependency on the following headers:
- drivers/usb/core/hdc.h (struct usb_hcd and various routines)
- drivers/usb/core/hub.h (couple of constants)
Because those headers are not part of include/, it makes it quite difficult
to compile them as standalone modules (e.g.: against pre-compiled kernel).

hdc.c and hub.c are relatively self-contained and could be moved to e.g.: include/linux/usb/.

What do you think?

Thanks,
	Eric.
