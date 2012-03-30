Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760588Ab2C3KA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:00:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39806 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201Ab2C3KAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:00:51 -0400
Date: Fri, 30 Mar 2012 12:00:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: menuconfig looks funny since recently, i.e. USB gains on importance
 :)
Message-ID: <20120330100056.GA27427@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <greg@kroah.com>, linux-usb@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

Linus tree from today gives the following in menuconfig:


...
  │ │                            Graphics support  --->
  │ │                        < > Sound card support  --->
  │ │                        [*] HID Devices  --->
  │ │                        [*] USB support  --->
  │ │                        <*> Support for Host-side USB
  │ │                        [ ]   USB verbose debug messages
  │ │                        [*]   USB announce new devices
  │ │                              *** Miscellaneous USB options ***
  │ │                        [ ]   USB device filesystem (DEPRECATED)
  │ │                        [ ]   USB device class-devices (DEPRECATED)
  │ │                        [ ]   Dynamic USB minor allocation
  │ │                        [*]   USB runtime power management (autosuspend) and wakeup
  │ │                        [ ]     OTG support
  │ │                        <*> USB Monitor
  │ │                        < > Support WUSB Cable Based Association (CBA)
  │ │                            *** USB Host Controller Drivers ***
  │ │                        < > Cypress C67x00 HCD support
  │ │                        <M> xHCI HCD (USB 3.0) support (EXPERIMENTAL)
  │ │                        [ ]   Debugging for the xHCI host controller
  │ │                        <M> EHCI HCD (USB 2.0) support
  │ │
  │ │                        [ ]   Root Hub Transaction Translators
  │ │                        [ ]   Improved Transaction Translator scheduling
  │ │                        < > OXU210HP HCD support
  │ │                        < > ISP116X HCD support
  │ │                        < > ISP 1760 HCD support
  │ │                        < > ISP1362 HCD support
  │ │                        <M> OHCI HCD support
...

This is the "Device Drivers" menu and all the USB-related options should
appear in the submenu "USB support" but they're merged with the "Device
Drivers" menu. Looks like someone funnied up Kconfig somewhere...

Thanks.

-- 
Regards/Gruss,
Boris.
