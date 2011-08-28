Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab1H1KDz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 06:03:55 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:59563 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab1H1KDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 06:03:52 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Harald Dunkel <harri@afaics.de>
Subject: Re: 3.0.3 + Bluetooth USB Dongle: no success without noapic
Date: Sun, 28 Aug 2011 12:07:09 +0200
User-Agent: KMail/1.13.5 (Linux/3.1.0-rc3-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4E5A0F45.9090302@afaics.de>
In-Reply-To: <4E5A0F45.9090302@afaics.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108281207.10071.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 28. August 2011, 11:49:57 schrieb Harald Dunkel:
> Hi folks,
> 
> If I plugin a Cambridge Bluetooth USB dongle, then I get
> 
> [   91.589073] usb 2-5: new full speed USB device number 8 using ohci_hcd
> [   91.709067] usb 2-5: device descriptor read/64, error -62
> [   91.930059] usb 2-5: device descriptor read/64, error -62
> [   92.144054] usb 2-5: new full speed USB device number 9 using ohci_hcd
> [   92.264073] usb 2-5: device descriptor read/64, error -62
> [   92.485064] usb 2-5: device descriptor read/64, error -62
> [   92.699091] usb 2-5: new full speed USB device number 10 using ohci_hcd
> [   93.103040] usb 2-5: device not accepting address 10, error -62
> [   93.216102] usb 2-5: new full speed USB device number 11 using ohci_hcd
> [   93.620038] usb 2-5: device not accepting address 11, error -62
> [   93.620072] hub 2-0:1.0: unable to enumerate USB device on port 5
> 
> Booting with noapic fixes this problem.

Do any other USB devices work on that OHCI?

	Regards
		Oliver

