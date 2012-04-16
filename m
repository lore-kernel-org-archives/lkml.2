Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab2DPKbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 06:31:36 -0400
Received: from forward3.mail.yandex.net ([77.88.46.8]:44053 "EHLO
	forward3.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab2DPKbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 06:31:35 -0400
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Apr 2012 06:31:34 EDT
Date: Mon, 16 Apr 2012 14:22:35 +0400
From: Oleg <lego12239@yandex.ru>
To: linux-kernel@vger.kernel.org
Subject: usb-to-serial converter problem
Message-ID: <20120416102235.GA22599@localhost>
Reply-To: Oleg <lego12239@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi, all.

  I have a strange problem with my usb-to-serial converter TU-S9
(http://www.trendnet.com/products/proddetail.asp?prod=265_TU-S9&cat=32). When i
attach it, i see /dev/ttyUSB0 device, but i cann't communicate with a switch
console from minicom. minicom show nothing, just like no switch at all on
another side of TU-S9. On my old notebook dell inspiron 1501 it worked fine, on
another machine it works fine, but on my new dell inspiron n5110 it doesn't
work correctly.
  Now I'm using Debian 6, vanilla kernel 3.2.14. When TU-S9 is connected, dmesg
show:

usb 3-2: new full-speed USB device number 3 using xhci_hcd
xhci_hcd 0000:0b:00.0: WARN: short transfer on control ep
xhci_hcd 0000:0b:00.0: WARN: short transfer on control ep
xhci_hcd 0000:0b:00.0: WARN: short transfer on control ep
pl2303 3-2:1.0: pl2303 converter detected
usb 3-2: pl2303 converter now attached to ttyUSB0

  What i do wrong?
  May be the problem exist bacause of inspiron n5110 have no usb 1.1 host?

  Thanks.
